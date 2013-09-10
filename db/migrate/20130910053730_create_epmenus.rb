class CreateEpmenus < ActiveRecord::Migration
  def change
    create_table :epmenus do |t|
      t.string :title

      t.timestamps
    end
  end
end
