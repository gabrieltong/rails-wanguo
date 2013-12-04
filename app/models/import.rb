# encoding: UTF-8
require 'zip/zipfilesystem'

require 'roo'
class Import < ActiveRecord::Base
  attr_accessible :file, :title, :state

  has_attached_file :file

  validates_attachment :file, :presence => true
  
  State = %w(laws freelaws questions eps laws_zip freelaws_zip)

  def self.import_all
    Import.freelaws.each {|i|i.import}
    Import.laws.each {|i|i.import}
    Import.questions.each {|i|i.import}
    Import.eps.each {|i|i.import}
  end

  def self.import_all_v2
    Import.laws_zip.each {|i|i.import}
  end
  # validate :validate_laws,:if=>"state = 'laws'"
  # validate :validate_freelaws,:if=>"state = 'freelaws'"
  # validate :validate_questions,:if=>"state = 'questions'"
  # validate :validate_eps,:if=>"state = 'eps'"

  def validate_laws
    data = open
    unless s[0[0..6]] == %w(学科 文件名称 分类 法条章 法条节 内容 关联考点)
      errors.add(:file, "法条班格式错误")
    end
  end

  def validate_freelaws
    data = open
    unless s[0[0..5]] == %w(学科 文件名称 分类 法条章 法条节 内容)
      errors.add(:file, "法条格式错误")
    end
  end

  def validate_questions
    data = open
    unless s[0][0..5] == %w(类型 分值 真题题号 题干 正确答案 解析)
      errors.add(:file, "问题格式错误")
    end
  end

  def validate_eps
    data = open
    unless s[0][0..5] == %w(一级目录 二级目录 知识点（考点） 真题题号和选项 法条编号)
      errors.add(:file, "知识点格式错误")
    end
  end


  def open(options={})
    options = {:path=>file.path,:type => file_content_type, :sheet=>0}.merge(options)
    s = nil
    begin
      s = Roo::Excel.new(options[:path])
    rescue
    end if s == nil

    begin
      s = Roo::Excelx.new(options[:path])
    rescue
    end if s == nil

    if s
      s.sheets.each_with_index do |sheet,index|
        s.default_sheet = s.sheets[index]
        data = s.to_a
        return data if data[0].size > 3
      end
      s.default_sheet = s.sheets[options[:sheet]]
      s.to_a
    else
      s
    end
  end

  state_machine :state,:initial=>:freelaws do 
    state :laws_zip do 
  #     validates_attachment :file, :content_type => {
  #   :content_type=>["application/vnd.ms-excel",   
  #            'application/octet-stream',
  #            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
  #          ]
  # } 
      def import 
        base = 'tmp'
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
        Dir.entries(target).delete_if {|i|i=='.'||i=='..'}.each do |two|
          two_path = "#{target}/#{two}"
          if File.directory? two_path
            Dir.entries(two_path).delete_if {|i|i=='.'||i=='..'}.each do |other|
              data = open(:path=>"#{two_path}/#{other}",:type=>'application/vnd.ms-excel',:sheet=>1)

              # 导入法条与免费法条
              if data[0][0..4] == %w(法条编号 编 章 节 法条内容)
                one = Law.find_or_create_by_title name.strip
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
          else
            data = open :path=>"#{two_path}",:type=>'application/vnd.ms-excel',:sheet=>1
            next unless data
            # 更新法条班
            # p '.'*100
            #   p data[0]
            if data[0][0..3] == %w(法条编号 音频讲解文件 真题编号 知识点)

              data[1..-1].each do |row|
                p '.'*100
                p row
                node = Law.find_by_number(row[0])
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
            # 导入真题
            if data && data[0] == %w(真题题号 标题 类型 分值 答案 解析一 解析三 选项A 选项A解析 选项B 选项B解析 选项C 选项C解析 选项D 选项D解析)
              data[1..-1].each do |row|
                q = Question.find_or_create_by_title row[1].strip
                q.state = row[2]
                q.score = row[3]
                q.num = row[0].to_i
                q.title = row[1]
                q.answer = row[4]
                q.description = row[5]
                q.description3 = row[6]
                q.choices = []
                q.choices_description = []
                row[7..-1].each_with_index do |cell,index|
                  if(index%2 == 0)
                    q.choices.push cell
                  else
                    q.choices_description.push cell
                  end
                end
                q.save
              end
            end
            # 导入知识点
            if data && data[0][0..4] == %w(一级目录 二级目录 知识点（考点） 真题题号和选项 法条编号)
              data[1..-1].each do |row|
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
      end
    end

    state :freelaws_zip do 
      def import 
        base = 'tmp'
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

        one = Freelaw.find_or_create_by_title name.strip
        Dir.entries(target).delete_if {|i|i=='.'||i=='..'}.each do |two|
          two_path = "#{target}/#{two}"
          if File.directory? two_path
            Dir.entries(two_path).delete_if {|i|i=='.'||i=='..'}.each do |other|
              data = open("#{two_path}/#{other}",'application/vnd.ms-excel',1)

              if data[0][0..3] == %w(法条编号 章 节 法条内容)
                two = one.children.find_or_create_by_title other.split('.')[0..-2].join('.').strip
                three_title = ''
                data[1..-1].each do |row|
                  three_title = row[1] unless row[1].blank? 
                  three_title = '第一章' if three_title.blank?
                  three = two.children.find_or_create_by_title three_title.strip
                  four = three.children.find_or_create_by_title row[3].strip
                  four.save
                end
              end
            end
          end
        end
      end
    end

    state :laws do
      def import
        import_laws
      end
    end

    state :freelaws do
      def import
        import_freelaws
      end
    end

    state :questions do
      def import
        # import_questions
        import_questions_v2
      end
    end

    state :eps do
      def import
        import_eps
      end
    end

    state :eps,:questions,:freelaws,:laws do 
      validates_attachment :file, :content_type => {
    :content_type=>["application/vnd.ms-excel",   
             'application/octet-stream',
             "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
           ]
  } 
    end

  end

  # ppp state_machine.states
  state_machine.states.map do |state|
    # ppp state.name.to_s
    scope state.name, :conditions => { :state => state.name.to_s }
  end
end
