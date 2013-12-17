class Book < ActiveRecord::Base
  attr_accessible :author, :details, :press, :price, :taobao, :title,:file,:published_at
  has_attached_file :file

  validates :author, :details, :press, :price, :taobao, :title,:file,:presence=>true
  validates_attachment :file,:presence=>true
  validates :price,:numericality => { :only_integer => true }
  def as_json(options={})
    super({:methods=>[:file_url]}.merge options)
  end

	def file_url
    file.url
  end
end
