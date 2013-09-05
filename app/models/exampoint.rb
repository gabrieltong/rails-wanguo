class Exampoint < ActiveRecord::Base
  attr_accessible :title

  has_and_belongs_to_many :laws
  has_and_belongs_to_many :freelaws
end
