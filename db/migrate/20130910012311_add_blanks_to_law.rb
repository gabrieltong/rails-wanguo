class AddBlanksToLaw < ActiveRecord::Migration
  def change
  	add_column :laws,:blanks,:text
  end
end
