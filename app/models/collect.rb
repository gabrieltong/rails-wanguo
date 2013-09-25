class Collect < ActiveRecord::Base
  attr_accessible :collectable_id, :collectable_type, :user_id
  belongs_to :user
  belongs_to :collectable, :polymorphic => true

	def self.add(user,collectable)  
		if Collect.where(:user_id=>user.id,:collectable_type=>collectable.class,:collectable_id=>collectable.id).count == 0
			collect = user.collects.build
			collect.collectable = collectable
			collect.save
		else
			return false
		end
	end

	def self.remove(user,collectable)  
		Collect.where(:user_id=>user.id,:collectable_type=>collectable.class,:collectable_id=>collectable.id).each do |collect|
			collect.destroy
		end
	end

	def self.is_collected(user,collectable)
		Collect.where(:user_id=>user.id,:collectable_type=>collectable.class,:collectable_id=>collectable.id).count()>0
	end
end

WgCollectAdapter
Collect.setup