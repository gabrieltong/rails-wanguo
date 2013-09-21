class AddScoreToLaws < ActiveRecord::Migration
  def change
    add_column :laws, :score, :integer
  end
end
