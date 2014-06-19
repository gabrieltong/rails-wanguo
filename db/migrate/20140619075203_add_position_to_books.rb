class AddPositionToBooks < ActiveRecord::Migration
  def change
    add_column :books, :position, :integer, {:default=>1}
  end
end
