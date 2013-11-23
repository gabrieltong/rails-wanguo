class DropColumnBrief < ActiveRecord::Migration
  def up
  	remove_column :laws,:brief
  	remove_column :freelaws,:brief
  end

  def down
  end
end
