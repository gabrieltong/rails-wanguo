class AddAssignedAtToCaptcha < ActiveRecord::Migration
  def change
    add_column :captchas, :assigned_at, :datetime
  end
end
