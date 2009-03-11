class ConnectGroupTypeToGroup < ActiveRecord::Migration
  def self.up
    add_column :groups, :group_type_id, :integer
    remove_column :groups, :type
  end

  def self.down
    add_column :groups, :type, :string
    remove_column :groups, :group_type_id
  end
end
