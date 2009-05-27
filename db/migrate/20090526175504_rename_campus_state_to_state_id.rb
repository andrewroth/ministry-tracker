class RenameCampusStateToStateId < ActiveRecord::Migration
  def self.up
    rename_column :campuses, :state, :state_id
  end

  def self.down
    rename_column :campuses, :state_id, :state
  end
end
