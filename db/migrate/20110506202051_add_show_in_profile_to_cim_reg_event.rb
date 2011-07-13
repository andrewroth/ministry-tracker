class AddShowInProfileToCimRegEvent < ActiveRecord::Migration
  def self.up
    add_column CimRegEvent.table_name, :hide_from_profile, :boolean, :default => false
  end

  def self.down
    remove_column CimRegEvent.table_name, :hide_from_profile 
  end
end
