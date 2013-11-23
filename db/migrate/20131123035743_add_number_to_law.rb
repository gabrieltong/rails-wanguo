class AddNumberToLaw < ActiveRecord::Migration
  def change
    add_column :laws, :number, :integer
  end
end
