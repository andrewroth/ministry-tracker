class AddGroupInvolvementsGroupIdIndex < ActiveRecord::Migration
  def self.up
    add_index(:group_involvements, :group_id)
  end

  def self.down
    remove_index(:group_involvements, :column => :group_id)
  end
end
