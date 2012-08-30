class AddTablesClauseToSearches < ActiveRecord::Migration
  def self.up
    add_column :searches, :tables_clause, :text
  end

  def self.down
    remove_column :searches, :tables_clause
  end
end
