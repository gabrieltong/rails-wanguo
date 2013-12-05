class Book < ActiveRecord::Base
  attr_accessible :author, :details, :press, :price, :taobao, :title,:file
  has_attached_file :file

  def as_json(options={})
    super({:methods=>[:file_url]}.merge options)
  end

  def file_url
    file.url
  end
end
