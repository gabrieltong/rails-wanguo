class AddFileToBooks < ActiveRecord::Migration
  def change
    add_column :books, :file_file_name, :string
    add_column :books, :file_content_type, :string
    add_column :books, :file_file_size, :integer
    add_column :books, :file_updated_at, :datetime    
  end
end
