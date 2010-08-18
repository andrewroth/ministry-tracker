class AddTypeToMinistries < ActiveRecord::Migration
  def self.up
    add_column Ministry.table_name, :type, :string
  end

  def self.down
    remove_column Ministry.table_name, :type, :string
  end
end
