class AddSoundToLaw < ActiveRecord::Migration
  def change
    add_column :laws, :sound, :string
  end
end
