class Freelaw < ActiveRecord::Base
  attr_accessible :ancestry, :content, :title
  has_ancestry :cache_depth=>true

  has_and_belongs_to_many :exampoints

  acts_as_collectable
  
  before_save do |instance|
  	instance.content = '' if instance.content == nil
  	instance.brief = '' if instance.brief == nil
  	instance.category = '' if instance.category == nil
  	instance.state = '' if instance.state == nil
  end
end
