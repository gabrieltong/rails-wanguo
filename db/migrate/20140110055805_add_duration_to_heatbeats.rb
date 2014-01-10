class AddDurationToHeatbeats < ActiveRecord::Migration
  def change
    add_column :heartbeats, :duration, :integer
  end
end
