class AddColumnToCaptcha < ActiveRecord::Migration
  def change
    add_column :captchas, :state, :string
    add_column :captchas, :expired_at, :datetime
  end
end
