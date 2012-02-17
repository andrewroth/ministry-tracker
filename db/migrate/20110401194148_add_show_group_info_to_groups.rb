class AddShowGroupInfoToGroups < ActiveRecord::Migration
  def self.up
    add_column Group.table_name, :show_group_info, :boolean, :default => false
  end

  def self.down
    remove_column Group.table_name, :show_group_info
  end
end
