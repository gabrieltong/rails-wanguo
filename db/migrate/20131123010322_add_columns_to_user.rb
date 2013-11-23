class AddColumnsToUser < ActiveRecord::Migration
  def change
  	add_column :users,:qq,:integer
  	add_column :users,:phone,:integer
  	add_column :users,:signature,:text
  end
end
