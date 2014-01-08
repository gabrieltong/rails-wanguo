class Question < ActiveRecord::Base
  include IsCollected
  
  attr_accessible :answer, :choices, :description, :num, :score, :state, :title
  serialize :choices
  serialize :choices_description  
  
  has_many :ep_questions
  has_many :histories
  acts_as_collectable
  
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

  def self.zhentis
    year_first = Question.order('num asc').limit(1).first.num.to_s[0..3].to_i
    year_last = Question.order('num desc').limit(1).first.num.to_s[0..3].to_i
    (year_first..year_last).to_a.map do |year|
      {
        :year=>year,
        :count1=>Question.where("`num` like '?01%' ",year).count(),
        :count2=>Question.where("`num` like '?02%' ",year).count(),
        :count3=>Question.where("`num` like '?03%' ",year).count()
      }
    end
  end

  def self.zhenti(year,volumn)
    relation = Question.where("`num` like '#{year}#{volumn}%' ")
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
    right_count*1.0/answered_count
  end
end
