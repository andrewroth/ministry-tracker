class RenameAddressTypeColumn < ActiveRecord::Migration
  def self.up
    rename_column Address.table_name, :type, :address_type
  end

  def self.down
    rename_column Address.table_name, :address_type, :type
  end
end
