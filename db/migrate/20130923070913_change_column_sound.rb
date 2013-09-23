class ChangeColumnSound < ActiveRecord::Migration
  def up
    change_column :laws,:sound,:string,:default=>''
  end

  def down
    change_column :laws,:sound,:string
  end
end
