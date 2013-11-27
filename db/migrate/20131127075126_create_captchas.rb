class CreateCaptchas < ActiveRecord::Migration
  def change
    create_table :captchas do |t|
      t.integer :user_id
      t.string :title
      t.datetime :used_at

      t.timestamps
    end
  end
end
