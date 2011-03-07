class AddInDirectorySearchInGroupTypes < ActiveRecord::Migration
  def self.up
    add_column GroupType.table_name, :in_directory_search_in, :boolean, :default => false
  end

  def self.down
    remove_column GroupType.table_name, :in_directory_search_in
  end
end
