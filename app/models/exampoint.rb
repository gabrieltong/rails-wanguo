class Exampoint < ActiveRecord::Base
  attr_accessible :title

  has_and_belongs_to_many :laws,:uniq=>true
  has_and_belongs_to_many :freelaws,:uniq=>true
  has_and_belongs_to_many :epmenus,:uniq=>true
end
