class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.string :title
      t.text :details
      t.string :url

      t.timestamps
    end
  end
end
