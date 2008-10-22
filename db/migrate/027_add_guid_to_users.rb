class AddGuidToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :guid, :string
    add_column :users, :email_validated, :boolean
    add_column :addresses, :email_validated, :boolean
    add_index :addresses, :email
    add_index :users, [:guid], :unique => true
  end

  def self.down
    remove_column :users, :guid
    remove_column :users, :email_validated
    remove_column :addresses, :email_validated
    remove_index :addresses, :email
    remove_index :users, :column => :guid
  end
end
