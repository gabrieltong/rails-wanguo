class School < ActiveRecord::Base
  attr_accessible :details, :title, :url,:file,:city,:price,:started_at
  has_attached_file :file

  validates :details, :title, :url,:file,:city,:price,:started_at,:presence=>true
  validates_attachment :file,:presence=>true
  def as_json(options={})
    super({:methods=>[:file_url]}.merge options)
  end

  def file_url
    file.url
  end
end
