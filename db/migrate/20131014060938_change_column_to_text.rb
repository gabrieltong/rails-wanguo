class ChangeColumnToText < ActiveRecord::Migration
  def up
    change_column :questions,:title,:text
  end

  def down
    change_column :questions,:title,:string
  end
end
