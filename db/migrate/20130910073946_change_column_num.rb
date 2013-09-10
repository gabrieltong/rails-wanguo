class ChangeColumnNum < ActiveRecord::Migration
  def up
  	change_column :questions,:num,:integer
  	add_index :questions,:num
  end

  def down
  	change_column :questions,:num,:string
  	remove_index :questions,:num
  end
end
