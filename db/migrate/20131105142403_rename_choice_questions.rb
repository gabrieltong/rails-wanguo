class RenameChoiceQuestions < ActiveRecord::Migration
  def up
  	rename_column :questions,:choice_description,:choices_description
  end

  def down
  	rename_column :questions,:choices_description,:choice_description
  end
end
