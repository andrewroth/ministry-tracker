class ChangeAddressTypeCol < ActiveRecord::Migration
  def self.up
    rename_column :addresses, :address_type, :type
  end

  def self.down
    rename_column :addresses, :type, :address_type
  end
end
