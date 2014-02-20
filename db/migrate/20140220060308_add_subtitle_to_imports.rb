class AddSubtitleToImports < ActiveRecord::Migration
  def change
    add_column :imports, :subtitle, :string
  end
end
