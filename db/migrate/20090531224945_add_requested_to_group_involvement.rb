class AddRequestedToGroupInvolvement < ActiveRecord::Migration
  def self.up
    add_column :group_involvements, :requested, :boolean
  end

  def self.down
    remove_column :group_involvements, :requested
  end
end
