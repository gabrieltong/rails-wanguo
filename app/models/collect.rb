class Collect < ActiveRecord::Base
  attr_accessible :collectable_id, :collectable_type, :user_id
  belongs_to :user
  belongs_to :collectable, :polymorphic => true
end
