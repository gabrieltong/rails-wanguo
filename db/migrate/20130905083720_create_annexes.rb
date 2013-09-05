class CreateAnnexes < ActiveRecord::Migration
  def change
    create_table :annexes do |t|
      t.string :title
      t.integer :law_id
      t.string :state

      t.timestamps
    end
  end
end
