class ImportError < ActiveRecord::Base
  attr_accessible :import_id, :title
  belongs_to :import
end
