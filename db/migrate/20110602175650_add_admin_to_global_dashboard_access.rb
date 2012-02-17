class AddAdminToGlobalDashboardAccess < ActiveRecord::Migration
  def self.up
    add_column :global_dashboard_accesses, :admin, :boolean, :default => false
  end

  def self.down
    remove_column :global_dashboard_accesses, :admin
  end
end
