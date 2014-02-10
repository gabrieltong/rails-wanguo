class AddPositionToTodoLaw < ActiveRecord::Migration
  def change
    add_column :laws, :position, :integer,:default=>0
  end
end
