class AddColumnQuestionsNumber < ActiveRecord::Migration
  def up
  	add_column :laws,:questions_number,:text
  end

  def down
  end
end
