class CreatePhonesigns < ActiveRecord::Migration
  def change
    create_table :phonesigns do |t|
      t.string :phone
      t.string :sign
      t.string :kind
      t.timestamps
    end
  end
end
