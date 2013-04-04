class AddCivicrmIdToPerson < ActiveRecord::Migration
  def self.up
    add_column Person.table_name, :civicrm_id, :integer
    add_index Person.table_name, :civicrm_id
  end

  def self.down
  	remove_index Person.table_name, :civicrm_id
    remove_column Person.table_name, :civicrm_id
  end
end
