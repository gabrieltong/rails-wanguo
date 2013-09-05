class AddStateToFreelaws < ActiveRecord::Migration
  def change
    add_column :freelaws, :state, :string
    add_column :laws, :state, :string
  end
end
