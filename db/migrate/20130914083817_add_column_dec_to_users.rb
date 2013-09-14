class AddColumnDecToUsers < ActiveRecord::Migration
  def change
    add_column :users, :dec, :text
  end
end
