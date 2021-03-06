class Epmenu < ActiveRecord::Base
  attr_accessible :title
  has_ancestry :cache_depth=>true
  has_and_belongs_to_many :exampoints,:uniq=>true

  has_many :questions,:through=>:exampoints,:uniq=>true
end
