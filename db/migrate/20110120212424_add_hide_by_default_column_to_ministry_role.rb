class AddHideByDefaultColumnToMinistryRole < ActiveRecord::Migration
  def self.up
<<<<<<< HEAD
    add_column MinistryRole.table_name, :hide_by_default, :boolean, :default => false
  end

  def self.down
    remove_column MinistryRole.table_name, MinistryRole._(:hide_by_default)
=======
    add_column MinistryRole.table_name, :hide_by_default, :boolean, :default => false unless MinistryRole.columns_hash.has_key?("hide_by_default")
  end

  def self.down
    remove_column MinistryRole.table_name, MinistryRole._(:hide_by_default) if MinistryRole.columns_hash.has_key?("hide_by_default")
>>>>>>> c4c.fix
  end
end
