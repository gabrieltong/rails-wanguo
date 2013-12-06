class AlterStartedAtAndPublishedAt < ActiveRecord::Migration
  def up
    change_column :books,:published_at,:string
    change_column :schools,:started_at,:string
  end

  def down
  end
end
