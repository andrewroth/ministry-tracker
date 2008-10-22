class CreateStintLocations < ActiveRecord::Migration
  def self.up
    create_table :stint_locations do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :stint_locations
  end
end
