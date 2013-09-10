class Question < ActiveRecord::Base
  attr_accessible :answer, :choices, :description, :num, :score, :state, :title
  serialize :choices

  has_many :ep_questions
  has_many :a_eps,:through=>:ep_questions,:conditions=>{"ep_questions.state"=>'A'},:class_name => "Exampoint"
  has_many :b_eps,:through=>:ep_questions,:conditions=>{"ep_questions.state"=>'B'},:class_name => "Exampoint"
  has_many :c_eps,:through=>:ep_questions,:conditions=>{"ep_questions.state"=>'C'},:class_name => "Exampoint"
  has_many :d_eps,:through=>:ep_questions,:conditions=>{"ep_questions.state"=>'D'},:class_name => "Exampoint"
  has_many :e_eps,:through=>:ep_questions,:conditions=>{"ep_questions.state"=>'E'},:class_name => "Exampoint"
  has_many :f_eps,:through=>:ep_questions,:conditions=>{"ep_questions.state"=>'F'},:class_name => "Exampoint"
  has_many :g_eps,:through=>:ep_questions,:conditions=>{"ep_questions.state"=>'G'},:class_name => "Exampoint"
  has_many :h_eps,:through=>:ep_questions,:conditions=>{"ep_questions.state"=>'H'},:class_name => "Exampoint"
end
