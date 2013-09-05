class Annex < ActiveRecord::Base
  attr_accessible :law_id, :state, :title
  belongs_to :law
end
