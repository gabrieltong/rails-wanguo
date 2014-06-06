class ChangeKindQuestions < ActiveRecord::Migration
  def up
  	change_column :questions,:kind,:string,{:default=>'scope_zhenti'}
  end

  def down
  	change_column :questions,:kind,:string,{:default=>'zhenti'}
  end
end
