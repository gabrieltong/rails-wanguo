class AddAncestryToEpmenus < ActiveRecord::Migration
  def change
  	add_column :epmenus,:ancestry,:string
  	add_column :epmenus,:ancestry_depth,:integer

  	add_index :epmenus,:ancestry
  	add_index :epmenus,:ancestry_depth
  end
end
