class AddMissingIndexToPermission < ActiveRecord::Migration
  def self.up
    add_index(Permission.table_name, [:controller, :action], :name => "index_permissions_on_controller_and_action")
  end

  def self.down
    remove_index(Permission.table_name, :name => "index_permissions_on_controller_and_action")
  end
end
