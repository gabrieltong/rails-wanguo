class AddDayToHeartbeat < ActiveRecord::Migration
  def change
    add_column :heartbeats, :day, :date
  end
end
