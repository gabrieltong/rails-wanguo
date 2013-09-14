# encoding: UTF-8
require 'roo'
class Import < ActiveRecord::Base
  attr_accessible :file, :title, :state

  has_attached_file :file

  validates_attachment :file, :presence => true
  validates_attachment :file, :content_type => {
  	:content_type=>["application/vnd.ms-excel",     
             "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"]
  } 

  State = %w(laws freelaws questions eps)

  def self.import_all
    Import.freelaws.each {|i|i.import}
    Import.laws.each {|i|i.import}
    Import.questions.each {|i|i.import}
    Import.eps.each {|i|i.import}
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


  def open
  	if file_content_type == "application/vnd.ms-excel"
  		s = Roo::Excel.new(file.path)
  	end

  	if file_content_type == "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  		s = Roo::Excelx.new(file.path)
  	end

  	s.to_a
  end

  def import_laws
  	s = open

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
        import_questions
      end
    end

    state :eps do
      def import
        import_eps
      end
    end
  end

  # ppp state_machine.states
  state_machine.states.map do |state|
    # ppp state.name.to_s
    scope state.name, :conditions => { :state => state.name.to_s }
  end
end
