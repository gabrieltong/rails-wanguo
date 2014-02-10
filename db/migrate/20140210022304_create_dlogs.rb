class CreateDlogs < ActiveRecord::Migration
  def change
    create_table :dlogs do |t|
      t.integer :user_id
      t.text :content
      t.string :method
      t.text :params

      t.timestamps
    end
  end
end
