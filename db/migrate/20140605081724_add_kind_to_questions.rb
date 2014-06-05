class AddKindToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :kind, :string,{:default=>'zhenti'}
  end
end
