class ChangeColumnPhoneAndQq < ActiveRecord::Migration
  def up
    change_column :users,:phone,:string
    change_column :users,:qq,:string
  end

  def down
    change_column :users,:phone,:integer
    change_column :users,:qq,:integer
  end
end
