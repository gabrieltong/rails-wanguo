class Question < ActiveRecord::Base
  attr_accessible :answer, :choices, :description, :num, :score, :state, :title
  serialize :choices
  attr_accessor :current_user
  has_many :ep_questions
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

  def is_collected
    raise NoCurrentUser unless (current_user.is_a? User)
    Collect.is_collected(User.first,self)
  end

  def me
    [1,2,3]
  end

  class NoCurrentUser < StandardError
  end
end
