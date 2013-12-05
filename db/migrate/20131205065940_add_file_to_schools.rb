class AddFileToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :file_file_name, :string
    add_column :schools, :file_content_type, :string
    add_column :schools, :file_file_size, :integer
    add_column :schools, :file_updated_at, :datetime    
  end
end
