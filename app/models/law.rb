class Law < ActiveRecord::Base
  include IsCollected
  has_attached_file :sound  
  attr_accessible :ancestry, :content, :title, :score,:sound
  has_ancestry :cache_depth=>true
	serialize :blanks
  has_many :annexes
  has_and_belongs_to_many :exampoints,:uniq=>true
  has_many :questions,:through=>:exampoints,:uniq => true
  acts_as_collectable  
  before_save do |instance|
  	instance.content = '' if instance.content == nil
  	instance.brief = '' if instance.brief == nil
  	instance.category = '' if instance.category == nil
  	instance.state = '' if instance.state == nil
    instance.score = 0 if instance.state == nil
  end

  def as_json(options={})
    super({:methods=>[:sound_url]}.merge options)
  end

  def sound_url
    sound.url
  end
end
