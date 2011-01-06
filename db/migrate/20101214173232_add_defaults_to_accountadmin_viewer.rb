class AddDefaultsToAccountadminViewer < ActiveRecord::Migration
  def self.up
    change_column User.table_name, :guid, :string, :limit => 64, :null => true, :default => ''
    change_column User.table_name, :viewer_passWord, :string, :limit => 50, :null => true, :default => ''
  end

  def self.down
    change_column User.table_name, :guid, :string, :limit => 64, :null => false
    change_column User.table_name, :viewer_passWord, :string, :limit => 50, :null => false
  end
end
