class AddEpmenuToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :epmenu, :string
  end
end
