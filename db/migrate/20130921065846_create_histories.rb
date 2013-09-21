class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.integer :user_id
      t.integer :question_id
      t.integer :exampoint_id
      t.string :epmenu_id
      t.string :state

      t.timestamps
    end
    add_index :histories,:state
    add_index :histories,:question_id
    add_index :histories,:exampoint_id
    add_index :histories,:epmenu_id
    
  end
end
