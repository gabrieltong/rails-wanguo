
class Freelaw < ActiveRecord::Base
  include IsCollected
  extend GabSortable::ClassMethods
  include GabSortable::SingletonMethods  
  attr_accessible :ancestry, :content, :title, :number
  has_ancestry :cache_depth=>true

  has_and_belongs_to_many :exampoints

  acts_as_collectable
    
  before_save do |instance|
  	instance.content = '' if instance.content == nil
  	instance.category = '' if instance.category == nil
  	instance.state = '' if instance.state == nil
  end

  after_create do |instance|
    instance.build_position
  end
  
  def children_state
    children.first.try(:state)
  end
end
