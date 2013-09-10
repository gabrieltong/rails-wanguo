class AddIndexOnAncestry < ActiveRecord::Migration
  def up
  	add_index :laws,:ancestry
  	add_index :laws,:state
  end

  def down
  	remove_index :laws,:ancestry
  	remove_index :laws,:state
  end
end
