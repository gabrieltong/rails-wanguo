class Search < ActiveRecord::Base
	# Limit = 15

  attr_accessible :keyword, :result, :searchable, :user_id
  
  belongs_to :user
 	serialize :result

 	validates :user,:action,:result,:presence => true

  def self.validate_law_roots keyword,parents=Law.roots
  	result = parents.select do |item|
  		!item.subtree.where("title like ?", "%#{keyword}%").limit(1).blank?
  	end
  	result
  end

  def self.search who,action,searchable,keyword
  	# cache = get_cache who,action,searchable,keyword
  	# return cache if cache

  	result = case action
				  	when :validate_law_roots
				  		if searchable == Law
				  			validate_law_roots keyword,searchable.roots
				  		else
				  			validate_law_roots keyword,searchable.children
				  		end
				  	end

		set_cache(who,action,searchable,keyword,result)

		result
  end

  def self.set_cache(who,action,searchable,keyword,result)
  	s = Search.new 
		s.searchable_type = searchable_type(searchable)
		s.searchable_id = searchable_id(searchable)
		s.user = who
		s.action = action
		s.keyword = keyword
		s.result = result
		s.save
  end

  def self.get_cache(who,action,searchable,keyword)
  	Search.where(
  		:searchable_type=>searchable_type(searchable),
  		:searchable_id=>searchable_id(searchable),
  		:user_id=>who.id,
  		:action=>action,
  		:keyword=>keyword,
  	).order('created_at desc').limit(1)
  end

  def self.searchable_type(searchable)
  	(searchable.is_a? Class) ? searchable.to_s : searchable.class.to_s
  end

  def self.searchable_id(searchable)
		(searchable.is_a? Class) ? nil : searchable.id
  end
end

