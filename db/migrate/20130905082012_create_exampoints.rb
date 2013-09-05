class CreateExampoints < ActiveRecord::Migration
  def change
    create_table :exampoints do |t|
      t.string :title

      t.timestamps
    end
  end
end
