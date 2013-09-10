class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title
      t.integer :score
      t.string :num
      t.string :state
      t.text :description
      t.string :answer
      t.text :choices

      t.timestamps
    end
  end
end
