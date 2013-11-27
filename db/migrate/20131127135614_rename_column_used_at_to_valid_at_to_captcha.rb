class RenameColumnUsedAtToValidAtToCaptcha < ActiveRecord::Migration
  def up
  	rename_column :captchas,:used_at,:valid_at
  end

  def down
  	rename_column :captchas,:valid_at,:used_at
  end
end
