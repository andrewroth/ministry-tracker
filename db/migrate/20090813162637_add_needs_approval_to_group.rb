class AddNeedsApprovalToGroup < ActiveRecord::Migration
  def self.up
    add_column :groups, :needs_approval, :boolean
  end

  def self.down
    remove_column :groups, :needs_approval
  end
end
