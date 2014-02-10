class Dlog < ActiveRecord::Base
  attr_accessible :content, :method, :params, :user_id
  serialize :content
  serialize :params
  belongs_to :user
end
