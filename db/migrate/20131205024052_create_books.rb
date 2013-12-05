class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.string :press
      t.float :price
      t.string :author
      t.text :details
      t.text :taobao

      t.timestamps
    end
  end
end
