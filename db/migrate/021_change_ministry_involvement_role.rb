class ChangeMinistryInvolvementRole < ActiveRecord::Migration
  def self.up
    add_column :ministry_involvements, :ministry_role, :string
    remove_column :ministry_involvements, :ministry_role_id
    add_column :campus_involvements, :ministry_role, :string
    remove_column :campus_involvements, :ministry_role_id
    add_column :campus_involvements, :ministry_id, :integer
    add_index :campus_involvements, :ministry_id
    add_index :campus_involvements, :campus_id
    add_index :campus_involvements, :person_id
    add_index :ministry_involvements, :person_id
  end

  def self.down
    remove_column :ministry_involvements, :ministry_role
    add_column :ministry_involvements, :ministry_role_id, :integer
    remove_column :campus_involvements, :ministry_role
    add_column :campus_involvements, :ministry_role_id, :integer
    remove_index :campus_involvements, :ministry_id
    remove_column :campus_involvements, :ministry_id
    remove_index :campus_involvements, :campus_id
    remove_index :campus_involvements, :person_id
    remove_index :ministry_involvements, :person_id
  end
end
