class ChangeNumberToStringLaws < ActiveRecord::Migration
  def up
  	change_column :laws,:number,:string
  	change_column :freelaws,:number,:string
  end

  def down
  	change_column :laws,:number,:integer
  	change_column :freelaws,:number,:integer
  end
end
