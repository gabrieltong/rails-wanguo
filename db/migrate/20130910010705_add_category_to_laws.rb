class AddCategoryToLaws < ActiveRecord::Migration
  def change
    add_column :laws, :category, :string
    add_column :freelaws, :category, :string
  end
end
