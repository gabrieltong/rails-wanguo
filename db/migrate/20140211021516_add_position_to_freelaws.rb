class AddPositionToFreelaws < ActiveRecord::Migration
  def change
    add_column :freelaws, :position, :integer,:default=>0
  end
end
