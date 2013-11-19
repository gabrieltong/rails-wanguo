class RemoveColumnSoundFromLaws < ActiveRecord::Migration
  def up
  	remove_column :laws,:sound
  end

  def down
  end
end
