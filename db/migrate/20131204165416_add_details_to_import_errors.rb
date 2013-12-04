class AddDetailsToImportErrors < ActiveRecord::Migration
  def change
    add_column :import_errors, :details, :text
  end
end
