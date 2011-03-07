class AddShortNameToGroupTypes < ActiveRecord::Migration
  def self.up
    add_column GroupType.table_name, :short_name, :string
  end

  def self.down
    remove_column GroupType.table_name, :short_name
  end
end
