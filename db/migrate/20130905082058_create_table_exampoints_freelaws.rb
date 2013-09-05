class CreateTableExampointsFreelaws < ActiveRecord::Migration
  def up
    create_table :exampoints_freelaws,:id=>false do |t|
      t.integer :exampoint_id
      t.integer :freelaw_id
    end
    add_index :exampoints_freelaws,:exampoint_id
    add_index :exampoints_freelaws,:freelaw_id

    create_table :exampoints_laws,:id=>false do |t|
      t.integer :exampoint_id
      t.integer :law_id
    end
    add_index :exampoints_laws,:exampoint_id
    add_index :exampoints_laws,:law_id
  end

  def down
    drop_table :exampoints_laws
  end
end
