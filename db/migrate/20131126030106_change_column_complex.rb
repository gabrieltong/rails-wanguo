class ChangeColumnComplex < ActiveRecord::Migration
  def up
    change_column :users,:complex,:float,:default=>0
  end

  def down
    change_column :users,:complex,:float,:default=>nil
  end
end
