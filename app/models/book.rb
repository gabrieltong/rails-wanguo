class Book < ActiveRecord::Base
  attr_accessible :author, :details, :press, :price, :taobao, :title,:file,:published_at
  has_attached_file :file

  extend GabSortable::ClassMethods
  include GabSortable::SingletonMethods
  validates :author, :details, :press, :price, :taobao, :title,:file,:presence=>true
  validates_attachment :file,:presence=>true
  validates :price,:numericality => { :only_integer => false }
  def as_json(options={})
    super({:methods=>[:file_url]}.merge options)
  end

	def file_url
    file.url
  end

  def position_scope
    Book.order('position asc')
  end  

  def self.build_position
    Book.where(true).each_with_index do |law,index|
      law.build_position
    end
  end

  def self.ordered_roots
    roots.order('position asc')
  end
end
