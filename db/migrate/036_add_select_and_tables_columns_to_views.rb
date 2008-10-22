class AddSelectAndTablesColumnsToViews < ActiveRecord::Migration
  def self.up
    add_column :views, :select_clause, :string, :limit => 2000
    add_column :views, :tables_clause, :string, :limit => 2000
  end

  def self.down
    remove_column :views, :select_clause
    remove_column :views, :tables_clause
  end
end
