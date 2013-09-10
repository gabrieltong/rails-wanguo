class ChangeFreelawsTitle < ActiveRecord::Migration
  def up
  	change_column :freelaws,:title,:text
  end

  def down
  	change_column :freelaws,:title,:string
  end
end
