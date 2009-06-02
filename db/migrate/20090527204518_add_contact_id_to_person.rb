class AddContactIdToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :contact_id, :integer
  end

  def self.down
    remove_column :people, :contact_id
  end
end
