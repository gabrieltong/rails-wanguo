# encoding: UTF-8
require 'zip/zipfilesystem'

require 'roo'
class Import < ActiveRecord::Base
  attr_accessible :file, :title, :state

  has_attached_file :file

  validates_attachment :file, :presence => true
  
  State = %w(laws freelaws questions eps laws_zip)

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


  def open(path = file.path,type = file_content_type, sheet=0)

    s = nil
    begin
      s = Roo::Excel.new(path)
    rescue
    end if s == nil

    begin
      s = Roo::Excelx.new(path)
    rescue
    end if s == nil

    if s
      s.default_sheet = s.sheets[sheet]
      s.to_a
    else
      s
    end
  end

  def import_law_zip_v2
    Zip::ZipFile.open(file.path) do |zipfile|
      zipfile.each do |file|
        # do something with file
      end
    end
  end

  def import_questions_v2
    s = open
    if s[0][0..5] == %w(真题题号 标题 类型 分值 答案 解析)
      s[1..-1].each do |row|
        q = Question.new
        q.state = row[2]
        q.score = row[3]
        q.num = row[0].to_i
        q.title = row[1]
        q.answer = row[4]
        q.description = row[5]
        q.choices = row[6..-1]
        q.save
      end
      return true
    else
      :wrong_excel
    end
  end

  def import_laws
  	s = open
    p s
  	if s[0][0..6] == %w(学科 文件名称 分类 法条章 法条节 内容 关联考点)
	  	s[1..-1].each do |row|
	  		one = Law.find_or_create_by_title row[0]
	  		one.category = row[2]
	  		one.save 

	  		two = one.children.find_or_create_by_title row[1]

	  		three = two.children.find_or_create_by_title row[3]

	  		four = three.children.find_or_create_by_title row[5]

	  		four.exampoints = []
	  		row[6].to_s.split(/[，,]/).each do |ep|
	  			four.exampoints << Exampoint.find_or_create_by_title(ep)
	  		end
	  		four.brief = row[4]
	  		four.blanks = row[7..-1]
	  		four.save
	  	end
	  	return true
	  else
	  	:wrong_excel
	  end
  end

  def import_freelaws
  	s = open
  	if s[0][0..5] == %w(学科 文件名称 分类 法条章 法条节 内容)
	  	s[1..-1].each do |row|
	  		one = Freelaw.find_or_create_by_title row[0]
	  		one.category = row[2]
	  		one.save 

	  		two = one.children.find_or_create_by_title row[1]

	  		three = two.children.find_or_create_by_title row[3]

	  		four = three.children.find_or_create_by_title row[5]

	  		four.exampoints = []
	  		four.brief = row[4]
	  		four.save
	  	end
	  	return true
	  else
	  	:wrong_excel
	  end
  end

  def import_questions
  	s = open
  	if s[0][0..5] == %w(类型 分值 真题题号 题干 正确答案 解析)
  		s[1..-1].each do |row|
  			q = Question.new
  			q.state = row[0]
  			q.score = row[1]
  			q.num = row[2].to_i
  			q.title = row[3]
  			q.answer = row[4]
  			q.description = row[5]
  			q.choices = row[6..-1]
  			q.save
  		end
  		return true
  	else
  		:wrong_excel
  	end
  end

  def import_eps
  	s = open
  	if s[0][0..5] = %w(一级目录 二级目录 知识点（考点） 真题题号和选项 法条编号)
  		s[1..-1].each do |row|
  			menu = Epmenu.find_or_create_by_title(row[0])
  			sub = menu.children.find_or_create_by_title(row[1])
  			ep = Exampoint.find_or_create_by_title(row[2])
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
  		return true
  	else
  		:wrong_excel
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
        name = File.basename(file.path).split('.')[0]
        dir = File.dirname(file.path)
        tmp = "#{dir}/tmp"
        target = "#{tmp}/#{name}"
        `
        rm -rf #{tmp} &&
        mkdir #{tmp} &&
        cd #{tmp} &&
        unzip #{file.path}
        `

        one = Law.find_or_create_by_title name
        Dir.entries(target).delete_if {|i|i=='.'||i=='..'}.each do |two|
          two_path = "#{target}/#{two}"
          if File.directory? two_path
            Dir.entries(two_path).delete_if {|i|i=='.'||i=='..'}.each do |other|
              data = open("#{two_path}/#{other}",'application/vnd.ms-excel',1)

              if data[0] == %w(法条编号 章 节 法条内容 音频讲解文件 真题和选项编号 填空题编号 知识点)
                two = one.children.find_or_create_by_title other.split('.')[0]
                three_title = ''
                data[1..-1].each do |row|
                  three_title = row[1] unless row[1].blank? 
                  three_title = '第一章' if three_title.blank?
                  three = two.children.find_or_create_by_title three_title
                  four = three.children.find_or_create_by_title row[3]
                  four.sound = row[4]
                  four.brief = row[2]
                  four.exampoints = []
                  row[7].to_s.split(/[，,、]/).each do |ep|
                    four.exampoints << Exampoint.find_or_create_by_title(ep)
                  end
                  four.save
                end
              end

              if data[0] == %w(填空题编号 题目 分值 填空内容A 填空内容B 填空内容C)
                data[1..-1].each do |row|
                  relation = Law
                  lines = row[1].split("\n")
                  lines.each do |line|
                    line = line.gsub(/^[　 ]/,'')
                    relation = relation.where("`title` like ?","%#{line}%")
                  end
                  relation.limit(1).each do |four|
                    four.blanks = row[3..-1].delete_if{|i|i.blank?}
                    four.score = row[2]
                    four.save
                  end
                end
              end
            end
          else
            data = open("#{two_path}",'application/vnd.ms-excel',0)
            if data && data[0] == %w(真题题号 标题 类型 分值 答案 解析 选项A 选项B 选项C 选项D)
              data[1..-1].each do |row|
                q = Question.find_or_create_by_title row[1]
                q.state = row[2]
                q.score = row[3]
                q.num = row[0].to_i
                q.title = row[1]
                q.answer = row[4]
                q.description = row[5]
                q.choices = row[6..-1]
                q.save
              end
            end

            if data && data[0] == %w(一级目录 二级目录 知识点（考点） 真题题号和选项 法条编号)
              data[1..-1].each do |row|
                menu = Epmenu.find_or_create_by_title(row[0])
                sub = menu.children.find_or_create_by_title(row[1])
                ep = Exampoint.find_or_create_by_title(row[2])
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
