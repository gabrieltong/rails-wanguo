class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.integer :user_id
      t.string :searchable
      t.integer :level      
      t.string :keyword
      t.text :result
      t.timestamps
    end

    add_index :searches,:user_id
    add_index :searches,:searchable
    add_index :searches,:level    
    add_index :searches,:keyword
  end
end
