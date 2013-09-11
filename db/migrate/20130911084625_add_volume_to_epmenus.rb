class AddVolumeToEpmenus < ActiveRecord::Migration
  def change
  	add_column :epmenus,:volumn,:integer
  	add_index :epmenus,:volumn
  end
end
