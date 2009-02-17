class CreateGroupTypes < ActiveRecord::Migration
  def self.up
    create_table :group_types do |t|
      t.integer :ministry_id
      t.string :group_type
      t.timestamps
    end
  end

  def self.down
    drop_table :group_types
  end
end
