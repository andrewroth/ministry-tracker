class AddHideByDefaultColumnToMinistryRole < ActiveRecord::Migration
  def self.up
    add_column MinistryRole.table_name, :hide_by_default, :boolean, :default => false
  end

  def self.down
    remove_column MinistryRole.table_name, MinistryRole._(:hide_by_default)
  end
end
