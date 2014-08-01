class AddIndex2 < ActiveRecord::Migration
  def up
  	add_index :histories,:user_id
  	add_index :heartbeats,:beatable_type
  	add_index :heartbeats,:beatable_id
  	add_index :users,:username
  	add_index :users,:phone
  	add_index :captchas,:user_id
  	add_index :captchas,:state
  end

  def down
  end
end
