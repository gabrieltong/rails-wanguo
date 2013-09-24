class RemoveColumnLevel < ActiveRecord::Migration
  def up
  	remove_column :searches,:level
  end

  def down
  	add_column :searches,:level,:integer
  end
end
