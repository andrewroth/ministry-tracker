class AddUrlToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :url, :string, :limit => 2000
  end

  def self.down
    remove_column :people, :url
  end
end
