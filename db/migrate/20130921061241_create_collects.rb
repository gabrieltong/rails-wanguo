class CreateCollects < ActiveRecord::Migration
  def change
    create_table :collects do |t|
      t.integer :collectable_id
      t.string :collectable_type
      t.integer :user_id

      t.timestamps
    end
    add_index :collects,:collectable_id
    add_index :collects,:user_id
    add_index :collects,:collectable_type
  end
end
