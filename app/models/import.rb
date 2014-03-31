# encoding: UTF-8
require 'zip/zipfilesystem'

require 'roo'
class Import < ActiveRecord::Base
  attr_accessible :file, :title, :state,:subtitle

  has_attached_file :file

  validates_attachment :file, :presence => true

  has_many :import_errors
  
  State = [:audios, :freelaws, :laws, :questions, :eps]

  # def self.import_all
  #   Import.freelaws.each {|i|i.import}
  #   Import.laws.each {|i|i.import}
  #   Import.questions.each {|i|i.import}
  #   Import.eps.each {|i|i.import}
  # end

  # def self.import_all_v2
  #   Import.laws_zip.each {|i|i.import}
  # end

  validate :title,:presence=>true
  validate :validate_laws,:if=>"state == 'laws'"
  validate :validate_freelaws,:if=>"state == 'freelaws'"
  validate :validate_questions,:if=>"state == 'questions'"
  validate :validate_eps,:if=>"state == 'eps'"

  validates_attachment :file, :content_type => {
          :content_type=>["application/vnd.ms-excel",   
            'application/octet-stream',
            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
          ]
      },:unless=>"state == 'audios'"

  def validate_laws
    if self.file.queued_for_write[:original]
      data = open(self.file.queued_for_write[:original].path)
      unless data && data[0][0..6] == %w(法条编号 音频 真题 知识点 填空内容A 填空内容B 填空内容C)
        errors.add(:file, "法条班格式错误")
      end
    end
  end

  def validate_freelaws
    if self.file.queued_for_write[:original]
      data = open(self.file.queued_for_write[:original].path)
      p '<'*100
      p data
      unless data && data[0][0..4] == %w(法条编号 编 章 节 法条内容)
        errors.add(:file, "免费法条格式错误")
      end
    end
  end

  def validate_questions
    if self.file.queued_for_write[:original]
      data = open(self.file.queued_for_write[:original].path)
      unless data && data[0][0..14] == %w(真题题号 标题 类型 分值 答案 解析一 解析三 选项A 解析A 选项B 解析B 选项C 解析C 选项D 解析D)
        errors.add(:file, "问题格式错误")
      end
    end
  end

  def validate_eps
    if self.file.queued_for_write[:original]
      data = open(self.file.queued_for_write[:original].path)
      unless data && data[0][0..3] == %w(一级目录 二级目录 知识点（考点） 真题题号和选项)
        errors.add(:file, "知识点格式错误")
      end
    end
  end


  def open(path = self.file.path)
    s , data = nil,nil
    begin
      s = Roo::Excel.new(path)
    rescue
    end if s == nil

    begin
      s = Roo::Excelx.new(path)
    rescue
    end if s == nil

    begin
      s = Roo::OpenOffice.new(path)
    rescue
    end if s == nil


    if s
      s.sheets.each_with_index do |sheet,index|
        s.default_sheet = s.sheets[index]
        _data = s.to_a
        if (_data[0].size > 3)
          data = _data  
          break
        end
      end
    end
    self.import_errors.find_or_create_by_title path unless data
    data
  end

  state_machine :state,:initial=>'freelaws' do 
    state 'audios' do
      def import 
        target_dir = 'public/audio'
        `
        mkdir -p #{target_dir}
        `
        Zip::ZipFile.open(file.path) do |zipfile|
          zipfile.each do |file|
            target = "#{target_dir}/#{file.to_s}"
            zipfile.extract(file,target) unless File.exist?(target)
          end
          Dir.glob("#{target_dir}/*.mp3").each do |file|
            number =  File.basename(file,".*")
            law = Law.find_by_number(number)
            if law
              law.sound = File.open(file)
              law.save
            end
          end
          `
          rm -rf #{target_dir}
          `
        end
      end
    end

    state 'laws_zip' do 
      def import 
        base = 'tmp'
        # 得到zip包名
        name = File.basename(file.path).split('.')[0..-2].join('.').strip
        dir = File.dirname(file.path)
        tmp = "#{dir}/tmp"
        target = "#{tmp}/#{name}"
        `
        rm -rf #{tmp} &&
        mkdir #{tmp} &&
        cd #{tmp} &&
        unzip #{file.path}
        `

        one = Law.find_or_create_by_title name.strip
        Dir.entries(target).delete_if {|i|i=='.'||i=='..'}.sort.each do |two|
          two_path = "#{target}/#{two}"
          if File.directory? two_path
            Dir.entries(two_path).delete_if {|i|i=='.'||i=='..'}.sort.each do |other|
              path = "#{two_path}/#{other}"
              data = open(path)
              import_law(name,other,data)
              import_freelaw(name,other,data)
              update_law(data)
            end
          else
            data = open(two_path)
            update_law(data)
            import_question(data)
            import_ep(data)
          end
        end
      end
    end

    state 'freelaws_zip' do 
      def import
      end
    end

    state 'laws' do
      def import
        update_law(open)
      end
    end

    state 'freelaws' do
      def import
        import_freelaw(title,file_file_name,open)
        import_law(title,file_file_name,open)
      end
    end

    state 'questions' do
      def import
        import_question(open)
      end
    end

    state 'eps' do
      def import
        import_ep(open)
      end
    end

  end

  # ppp state_machine.states
  state_machine.states.map do |state|
    # ppp state.name.to_s
    scope state.name, :conditions => { :state => state.name.to_s }
  end

  def import_law(name,other,data)
    # 导入法条与免费法条
    if data &&  data[0] && data[0][0..4] == %w(法条编号 编 章 节 法条内容)
      one = Law.with_deleted.find_or_create_by_title name.strip
      data[1..-1].each do |row|
        last = one.children.with_deleted.find_or_create_by_title other.split('.')[0..-2].join('.').strip
        if row[1]
          last = last.children.with_deleted.find_or_initialize_by_title row[1].strip
          last.state = 'bian'
          last.save
        end

        if row[2]
          last = last.children.with_deleted.find_or_initialize_by_title row[2].strip
          last.state = 'zhang'
          last.save
        end

        if row[3]
          last = last.children.with_deleted.find_or_initialize_by_title row[3].strip
          last.state = 'jie'
          last.save
        end

        if row[4]
          last = last.children.with_deleted.find_or_initialize_by_number row[0]
          last.title = row[4].strip
          last.state = 'node'
          last.save
        end
      end
    end
  end

  def import_freelaw(name,other,data)
    # 导入法条与免费法条
    if data &&  data[0] && data[0][0..4] == %w(法条编号 编 章 节 法条内容)
      one = Freelaw.find_or_create_by_title name.strip
      data[1..-1].each do |row|
        last = one.children.find_or_create_by_title other.split('.')[0..-2].join('.').strip
        if row[1]
          last = last.children.find_or_initialize_by_title row[1].strip
          last.state = 'bian'
          last.save
        end

        if row[2]
          last = last.children.find_or_initialize_by_title row[2].strip
          last.state = 'zhang'
          last.save
        end

        if row[3]
          last = last.children.find_or_initialize_by_title row[3].strip
          last.state = 'jie'
          last.save
        end

        if row[4]
          last = last.children.find_or_initialize_by_title row[4].strip
          last.number = row[0]
          last.state = 'node'
          last.save
        end
      end
    end
  end

  def update_law(data)
    # 更新法条班
    if data && data[0] && data[0][0..3] == %w(法条编号 音频 真题 知识点)
      data[1..-1].each do |row|
        node = Law.with_deleted.find_by_number(row[0])
        if node
          node.ancestors.with_deleted.each do |item|
            item.recover
          end
          node.recover
          node.sound = row[1]
          node.exampoints = []
          row[3].to_s.split(/[，,、]/).each do |ep|
            node.exampoints << Exampoint.find_or_create_by_title(ep)
          end

          node.questions_number = []

          row[2].to_s.split(/[，,、]/).each do |number|
            node.questions_number.push number
          end

          node.blanks = row[4..-1].delete_if{|i|i.blank?}
          node.score = 1
          node.save
        end
      end
    end
  end
  def import_question(data)
    # 导入真题
    if data && data[0][0..14] == %w(真题题号 标题 类型 分值 答案 解析一 解析三 选项A 解析A 选项B 解析B 选项C 解析C 选项D 解析D)

      data[1..-1].each do |row|
        if row[1]
          q = Question.find_or_initialize_by_num row[0].to_i
          q.title = row[1].strip
          q.state = row[2]
          q.score = row[3]
          q.num = row[0].to_i
          q.title = row[1]
          q.answer = row[4]
          q.description = row[5]
          q.description3 = row[6]
          q.choices = []
          q.choices_description = []
          row[7..14].each_with_index do |cell,index|
            if(index%2 == 0)
              q.choices.push cell
            else
              q.choices_description.push cell
            end
          end
          q.save
        end
      end
    end
  end

  def import_ep(data)
    # 导入知识点
    if data && data[0] && data[0][0..3] == %w(一级目录 二级目录 知识点（考点） 真题题号和选项)
      data[1..-1].each do |row|
        if row[0] && row[1] && row[2] && row[3]
          menu = Epmenu.find_or_create_by_title(row[0].strip)
          sub = menu.children.find_or_create_by_title(row[1].strip)
          ep = Exampoint.find_or_create_by_title(row[2].strip)
          menu.exampoints << ep
          sub.exampoints << ep

          if row[3]
            row[3].split(',').each do |q|
              question_num = q.match(/\d+/).to_s
              
              question = Question.find_by_num(question_num)
              if question 
                choices = q.match(/[ABCDEFGH]+/).to_s
                if !choices.blank?
                  choices.split('').each do |choice|
                    ep_question = EpQuestion.find_or_create_by_exampoint_id_and_question_id_and_state(ep.id,question.id,choice)
                  end
                else
                  ep_question = EpQuestion.find_or_create_by_exampoint_id_and_question_id_and_state(ep.id,question.id,'')
                end
              end
            end
          end
        end
      end
    end
  end

  def self.fix_laws
    Law.all.each {|l|l.delete}
    Import.laws.each {|l|l.import}
  end
end
