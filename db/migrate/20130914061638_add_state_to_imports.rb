class AddStateToImports < ActiveRecord::Migration
  def change
    add_column :imports, :state, :string
    add_index :imports,:state
  end
end
