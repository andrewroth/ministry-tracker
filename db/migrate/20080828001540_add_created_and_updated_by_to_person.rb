class AddCreatedAndUpdatedByToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :updated_by, :integer
    add_column :people, :created_by, :integer
  end

  def self.down
    remove_column :people, :created_by
    remove_column :people, :updated_by
  end
end
