class RemoveContactIdFromPerson < ActiveRecord::Migration
  def self.up
    remove_column :people, :contact_id
  end

  def self.down
    add_column :people, :contact_id, :integer
  end
end
