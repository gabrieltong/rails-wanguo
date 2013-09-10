class CreateTableEpmenusesExampoints < ActiveRecord::Migration
  def up
  	create_table :epmenus_exampoints,:id=>false do |t|
  		t.integer :epmenu_id
  		t.integer :exampoint_id
  	end
  	add_index :epmenus_exampoints ,:epmenu_id
  	add_index :epmenus_exampoints ,:exampoint_id
  end

  def down
  	drop_table :epmenus_exampoints
  end
end
