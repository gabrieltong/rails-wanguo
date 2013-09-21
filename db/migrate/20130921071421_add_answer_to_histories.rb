class AddAnswerToHistories < ActiveRecord::Migration
  def change
    add_column :histories, :answer, :string
    add_index :histories,:answer
  end
end
