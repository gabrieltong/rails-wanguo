class Question < ActiveRecord::Base
  attr_accessible :answer, :choices, :description, :num, :score, :state, :title
  serialize :choices

  has_many :ep_questions
  
  has_many :global_eps,:through=>:ep_questions,:conditions=>{"ep_questions.state"=>''},:source => :exampoint
  has_many :a_eps,:through=>:ep_questions,:conditions=>{"ep_questions.state"=>'A'},:source => :exampoint
  has_many :b_eps,:through=>:ep_questions,:conditions=>{"ep_questions.state"=>'B'},:source => :exampoint
  has_many :c_eps,:through=>:ep_questions,:conditions=>{"ep_questions.state"=>'C'},:source => :exampoint
  has_many :d_eps,:through=>:ep_questions,:conditions=>{"ep_questions.state"=>'D'},:source => :exampoint
  has_many :e_eps,:through=>:ep_questions,:conditions=>{"ep_questions.state"=>'E'},:source => :exampoint
  has_many :f_eps,:through=>:ep_questions,:conditions=>{"ep_questions.state"=>'F'},:source => :exampoint
  has_many :g_eps,:through=>:ep_questions,:conditions=>{"ep_questions.state"=>'G'},:source => :exampoint
  has_many :h_eps,:through=>:ep_questions,:conditions=>{"ep_questions.state"=>'H'},:source => :exampoint
end
