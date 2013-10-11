class AddComplexToUsers < ActiveRecord::Migration
  def change
    add_column :users, :complex, :float
    add_index :users,:complex
  end
end
