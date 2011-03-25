class CreateGlobalDashboardAccesses < ActiveRecord::Migration
  def self.up
    create_table :global_dashboard_accesses do |t|
      t.string :guid
      t.string :fn
      t.string :ln
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :global_dashboard_accesses
  end
end
