class AddColumnsToSearch < ActiveRecord::Migration
  def change
    add_column :searches, :action, :string
    add_column :searches, :searchable_id,:integer

    add_index :searches,:action
		add_index :searches,:searchable_id

		rename_column :searches, :searchable, :searchable_type

  end
end
