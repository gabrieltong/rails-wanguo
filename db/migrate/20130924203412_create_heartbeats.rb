class CreateHeartbeats < ActiveRecord::Migration
  def change
    create_table :heartbeats do |t|
      t.integer :user_id
      t.string :state
      t.timestamps
    end
    add_index :heartbeats,:user_id
    add_index :heartbeats,:state
  end
end
