class CreateTempGroupInvolvements < ActiveRecord::Migration
  def self.up
    create_table :temp_group_involvements, :id => false do |t|
      t.integer :person_id
      t.string :group_involvements
    end

    add_index :temp_group_involvements, :person_id
  end

  def self.down
    drop_table :temp_group_involvements
  end
end
