# encoding: UTF-8
class Question < ActiveRecord::Base
  include IsCollected
  
  attr_accessible :answer, :choices, :description, :num, :score, :state, :title,:description3,:choices_description,:kind,:epmenu
  serialize :choices
  serialize :choices_description  
  
  has_many :ep_questions
  has_many :histories
  acts_as_collectable

  before_validation do |record|
    record.choices = record.choices || []
    record.choices_description = record.choices_description || []
    record.choices = JSON.parse(record.choices) if record.choices.class != Array
    record.choices_description = JSON.parse(record.choices_description) if record.choices_description.class != Array
  end  

  has_many :eps,:through=>:ep_questions,:source => :exampoint,:uniq=>true
  has_many :global_eps,:through=>:ep_questions,:conditions=>{"ep_questions.state"=>''},:source => :exampoint,:uniq=>true
  has_many :a_eps,:through=>:ep_questions,:conditions=>{"ep_questions.state"=>'A'},:source => :exampoint,:uniq=>true
  has_many :b_eps,:through=>:ep_questions,:conditions=>{"ep_questions.state"=>'B'},:source => :exampoint,:uniq=>true
  has_many :c_eps,:through=>:ep_questions,:conditions=>{"ep_questions.state"=>'C'},:source => :exampoint,:uniq=>true
  has_many :d_eps,:through=>:ep_questions,:conditions=>{"ep_questions.state"=>'D'},:source => :exampoint,:uniq=>true
  has_many :e_eps,:through=>:ep_questions,:conditions=>{"ep_questions.state"=>'E'},:source => :exampoint,:uniq=>true
  has_many :f_eps,:through=>:ep_questions,:conditions=>{"ep_questions.state"=>'F'},:source => :exampoint,:uniq=>true
  has_many :g_eps,:through=>:ep_questions,:conditions=>{"ep_questions.state"=>'G'},:source => :exampoint,:uniq=>true
  has_many :h_eps,:through=>:ep_questions,:conditions=>{"ep_questions.state"=>'H'},:source => :exampoint,:uniq=>true

  scope 'scope_zhenti', :conditions => { :kind =>'scope_zhenti'  }
  scope 'scope_moni', :conditions => { :kind =>'scope_moni'  }

  def self.zhentis
    year_first = 2000
    year_last = 2030
    (year_first..year_last).to_a.map do |year|
      {
        :year=>year,
        :count1=>Question.scope_zhenti.where("`num` like '?01%' ",year).count(),
        :count2=>Question.scope_zhenti.where("`num` like '?02%' ",year).count(),
        :count3=>Question.scope_zhenti.where("`num` like '?03%' ",year).count()
      }
    end.select do |item|
      item[:count1] !=0 || item[:count2] !=0 || item[:count3] !=0
    end
  end

  def self.zhenti(year,volumn)
    relation = Question.scope_zhenti.where("`num` like '#{year}#{volumn}%' ")
    relation
  end

  def answered_count
    histories.group('created_at').count().keys.count
  end

  def right_count
    histories.right.group('created_at').count().keys.count
  end

  def wrong_count
    histories.wrong.group('created_at').count().keys.count
  end

  def right_rate
    if answered_count == 0
      0
    else
      right_count*1.0/answered_count
    end
  end

  def self.clear_special_chars
    char = ''
    Question.where("title like ?", "%#{char}%").each do |q|
      q.title = q.title.gsub(char,'')
      q.save
    end

    Question.where("description like ?", "%#{char}%").each do |q|
      q.description = q.description.gsub(char,'')
      q.save
    end

    Question.where("choices like ?", "%#{char}%").each do |q|
      q.choices = q.choices.map {|c|c.gsub(char,'')}
      q.save
    end
    
    # .where("description like ?", "%#{char}%").where("choices like ?", "%#{char}%")    
  end

end
