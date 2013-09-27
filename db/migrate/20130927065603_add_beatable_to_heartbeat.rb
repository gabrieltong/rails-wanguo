class AddBeatableToHeartbeat < ActiveRecord::Migration
  def change
    add_column :heartbeats, :beatable_type, :string
    add_column :heartbeats, :beatable_id, :integer
  end
end
