class Law < ActiveRecord::Base
  attr_accessible :ancestry, :content, :title
  has_ancestry :cache_depth=>true
	serialize :blanks
  has_many :annexes
  has_and_belongs_to_many :exampoints,:uniq=>true

end
