class AddMinistryChildrenCount < ActiveRecord::Migration
  def self.up
    add_column :ministries, :ministries_count, :integer
    remove_column :users, :person_id
    add_column :permissions, :description, :string, :limit => 1000
  end

  def self.down
    remove_column :ministries, :ministries_count
    add_column :users, :person_id,       :integer, :null => false
    remove_column :permissions, :description
  end
end
