class ChangeComplexToDecimal < ActiveRecord::Migration
  def up
  	change_column :users, :complex, :decimal, precision: 5, scale: 4
  end

  def down
  end
end
