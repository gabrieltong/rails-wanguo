class School < ActiveRecord::Base
  attr_accessible :details, :title, :url,:file
  has_attached_file :file

  def as_json(options={})
    super({:methods=>[:file_url]}.merge options)
  end

  def file_url
    file.url
  end
end
