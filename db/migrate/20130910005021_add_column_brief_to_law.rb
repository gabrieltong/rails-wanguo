class AddColumnBriefToLaw < ActiveRecord::Migration
  def change
    add_column :laws, :brief, :string
    add_column :freelaws, :brief, :string
  end
end
