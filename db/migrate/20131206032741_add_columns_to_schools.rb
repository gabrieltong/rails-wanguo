class AddColumnsToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :city, :string
    add_column :schools, :price, :float
    add_column :schools, :started_at, :datetime
  end
end
