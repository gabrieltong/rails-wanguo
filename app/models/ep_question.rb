class EpQuestion < ActiveRecord::Base
  attr_accessible :exampoint_id, :question_id

  belongs_to :question
  belongs_to :exampoint
end
