class AddDescription3ToQuestions < ActiveRecord::Migration
  def change
  	add_column :questions,:description3,:text
  	add_column :questions,:choice_description,:text
  end
end
