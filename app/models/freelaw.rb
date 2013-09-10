class Freelaw < ActiveRecord::Base
  attr_accessible :ancestry, :content, :title
  has_ancestry :cache_depth=>true

  has_and_belongs_to_many :exampoints
  
end
