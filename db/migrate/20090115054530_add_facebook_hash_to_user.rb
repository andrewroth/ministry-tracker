class AddFacebookHashToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :facebook_hash, :string
  end

  def self.down
    remove_column :users, :facebook_hash
  end
end
