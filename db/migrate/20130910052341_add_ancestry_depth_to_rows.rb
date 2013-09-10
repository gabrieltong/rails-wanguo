class AddAncestryDepthToRows < ActiveRecord::Migration
  def change
    add_column :laws, :ancestry_depth, :integer,:default=>0
    add_column :freelaws, :ancestry_depth, :integer,:default=>0
  end
end
