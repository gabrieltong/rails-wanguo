class AddNumberToFreelaw < ActiveRecord::Migration
  def change
    add_column :freelaws, :number, :integer
  end
end
