class RemoveMinistryRoleColumnFromMinistryInvolvement < ActiveRecord::Migration
  def self.up
    remove_column :ministry_involvements, :ministry_role
  end

  def self.down
    add_column :ministry_involvements, :ministry_role, :string, :default => "Involved Student"
  end
end
