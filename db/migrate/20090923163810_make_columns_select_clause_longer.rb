class MakeColumnsSelectClauseLonger < ActiveRecord::Migration
  def self.up
    change_column Column.table_name, Column._(:select_clause), :text
  end

  def self.down
    change_column Column.table_name, Column._(:select_clause), :string
  end
end
