class AddApiKeysToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :api_key, :string
    add_column :users, :secret_key, :string
  end

  def self.down
    remove_column :users, :api_key
    remove_column :users, :secret_key
  end
end

