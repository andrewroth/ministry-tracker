class AddCampusAddress2 < ActiveRecord::Migration
  def self.up
    add_column :campuses, :address2, :string
    add_column :campuses, :county, :string
  end

  def self.down
    remove_column :campuses, :address2
    remove_column :campuses, :county
  end
end
