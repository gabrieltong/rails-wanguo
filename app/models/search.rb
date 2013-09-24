class Search < ActiveRecord::Base
  attr_accessible :keyword, :result, :searchable, :user_id

  def self.search_law_tree collection, keyword
  	valid = collection.where("title like ?", "%#{keyword}%")
  	invalid = collection - valid
  	invalid.each do |item|
  		valid.push item unless search_law_tree(item.children,keyword).blank?
  	end
  	valid
  end
end

