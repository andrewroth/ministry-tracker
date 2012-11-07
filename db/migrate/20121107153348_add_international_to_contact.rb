class AddInternationalToContact < ActiveRecord::Migration
  def self.up
    add_column Contact.table_name, :international, :boolean, :default => 0
  end

  def self.down
    remove_column Contact.table_name, :international
  end
end
