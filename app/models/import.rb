# encoding: UTF-8
require 'roo'
class Import < ActiveRecord::Base
  attr_accessible :file, :title

  has_attached_file :file

  validates_attachment :file, :presence => true
  validates_attachment :file, :content_type => {
  	:content_type=>["application/vnd.ms-excel",     
             "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"]
  } 

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
	  		row[6].to_s.split('，').each do |ep|
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
  			q.num = row[2]
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
  		end
  		return true
  	else
  		:wrong_excel
  	end
  end
end
