class CreateEpQuestions < ActiveRecord::Migration
  def change
    create_table :ep_questions do |t|
      t.integer :exampoint_id
      t.integer :question_id
      t.string :state
    end
    add_index :ep_questions , :exampoint_id
    add_index :ep_questions , :question_id
    add_index :ep_questions , :state
  end
end
