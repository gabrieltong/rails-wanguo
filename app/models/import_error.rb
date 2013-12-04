class ImportError < ActiveRecord::Base
  attr_accessible :import_id, :title, :details
  serialize :details
  belongs_to :import
end
