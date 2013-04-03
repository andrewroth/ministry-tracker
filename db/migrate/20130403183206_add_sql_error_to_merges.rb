class AddSqlErrorToMerges < ActiveRecord::Migration
  def self.up
    add_column :merges, :sql_error, :boolean
  end

  def self.down
    remove_column :merges, :sql_error
  end
end
