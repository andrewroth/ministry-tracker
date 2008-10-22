class AddJoinClauseToColumns < ActiveRecord::Migration
  def self.up
    add_column :columns, :join_clause, :string
  end

  def self.down
    remove_column :columns, :join_clause
  end
end
