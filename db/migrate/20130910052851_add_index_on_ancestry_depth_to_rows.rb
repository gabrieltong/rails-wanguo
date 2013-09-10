class AddIndexOnAncestryDepthToRows < ActiveRecord::Migration
  def change
  	add_index :laws,:ancestry_depth
  	add_index :freelaws,:ancestry_depth
  end
end
