class RemoveSalutationFromEmails < ActiveRecord::Migration
  def self.up
    remove_column :emails, :salutation
  end

  def self.down
    add_column :emails, :salutation, :string
  end
end
