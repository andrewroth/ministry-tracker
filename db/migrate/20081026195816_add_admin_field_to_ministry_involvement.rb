class AddAdminFieldToMinistryInvolvement < ActiveRecord::Migration
  def self.up
    add_column MinistryInvolvement.table_name, :admin, :boolean
  end

  def self.down
    remove_column MinistryInvolvement.table_name, :admin
  end
end
