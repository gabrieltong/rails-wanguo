class AddKeyToCollectable < ActiveRecord::Migration
  def change
    add_column :collects,:key1_id,:integer
    add_column :collects,:key2_id,:integer
    add_index :collects,:key1_id
    add_index :collects,:key2_id
  end
end
