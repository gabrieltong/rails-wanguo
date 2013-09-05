class CreateFreelaws < ActiveRecord::Migration
  def change
    create_table :freelaws do |t|
      t.string :title
      t.text :content
      t.string :ancestry

      t.timestamps
    end
    add_index :freelaws,:ancestry
  end
end
