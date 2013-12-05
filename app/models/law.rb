class Law < ActiveRecord::Base
  include IsCollected
  has_attached_file :sound  
  attr_accessible :ancestry, :content, :title, :score,:sound,:number
  has_ancestry :cache_depth=>true
	serialize :blanks
  serialize :questions_number
  has_many :annexes
  has_and_belongs_to_many :exampoints,:uniq=>true
  has_many :questions,:through=>:exampoints,:uniq => true
  acts_as_collectable  
  before_save do |instance|
  	instance.content = '' if instance.content == nil
  	instance.category = '' if instance.category == nil
  	instance.state = '' if instance.state == nil
    instance.score = 0 if instance.state == nil
  end

  scope 'node', :conditions => { :state => 'node' }

  def as_json(options={})
    super({:methods=>[:sound_url]}.merge options)
  end

  def sound_url
    sound_file_name.nil? ? '' : sound.url
  end

  def children_state
    children.first.try(:state)
  end

  def self.dup_freelaw
    Freelaw.each do |freelaw|
      law = Law.find_or_initialize_by_number 
    end
  end

  def self.destroy_freelaws
    Law.all.each do |l|
      if l.state == 'node' && l.blanks.blank? && l.exampoints.blank? 
        p '.'*50
        p "destroy law #{l.id}.#{l.title}"
        l.destroy
      end
    end
    Law.all.each do |l|
      if l.subtree.node.blank? 
        p "destroy law #{l.id}.#{l.title}"
        l.destroy
      end
    end
  end
end
