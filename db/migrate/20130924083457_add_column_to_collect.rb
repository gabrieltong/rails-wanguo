class AddColumnToCollect < ActiveRecord::Migration
  def change
    add_column :collects, :key3_id, :integer
  end
end
