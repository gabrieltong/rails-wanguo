class AddDeletedAtToLaw < ActiveRecord::Migration
  def change
    add_column :laws, :deleted_at, :datetime
  end
end
