class ChangeColumnsRow < ActiveRecord::Migration
  def up
  	change_column :laws,:title,:text
  end

  def down
  	change_column :laws,:title,:string
  end
end
