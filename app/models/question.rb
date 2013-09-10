class Question < ActiveRecord::Base
  attr_accessible :answer, :choices, :description, :num, :score, :state, :title
  serialize :choices
end
