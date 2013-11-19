class AddAttachToLaws < ActiveRecord::Migration
  def change
		add_column :laws, :sound_file_name, :string
    add_column :laws, :sound_content_type, :string
    add_column :laws, :sound_file_size, :integer
    add_column :laws, :sound_updated_at, :datetime  	
  end
end
