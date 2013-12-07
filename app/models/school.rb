# encoding: UTF-8
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

  def self.order_by_locality(locality)
  	locality = locality.gsub('市','')
  	items = []
  	level_1 = School.where(:city=>locality).order('id asc')
  	level_2 = School.where("`city` != ?",locality).order('id asc')
  	level_1.each {|i|items.push i}
  	level_2.each {|i|items.push i}
  	items
  end
end
