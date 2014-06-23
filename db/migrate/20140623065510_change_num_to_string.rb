class ChangeNumToString < ActiveRecord::Migration
  def up
  	change_column :questions,:num,:string
  end

  def down
  	change_column :questions,:num,:integer,{:default=>0}
  end
end
