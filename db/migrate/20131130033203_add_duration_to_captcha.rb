class AddDurationToCaptcha < ActiveRecord::Migration
  def change
    add_column :captchas, :duration, :integer
  end
end
