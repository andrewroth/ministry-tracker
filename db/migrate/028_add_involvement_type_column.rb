class AddInvolvementTypeColumn < ActiveRecord::Migration
  def self.up
    add_column :group_involvements, :level, :string
    add_column :groups, :type, :string
  end

  def self.down
    remove_column :group_involvements, :level
    remove_column :groups, :type
  end
end
