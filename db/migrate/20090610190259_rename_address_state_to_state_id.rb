class RenameAddressStateToStateId < ActiveRecord::Migration
  def self.up
    rename_column :addresses, :state, :state_id
  end

  def self.down
    rename_column :addresses, :state_id, :state
  end
end
