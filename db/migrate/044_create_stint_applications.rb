class CreateStintApplications < ActiveRecord::Migration
  def self.up
    create_table :stint_applications do |t|
      t.integer :stint_location_id, :person_id
      t.timestamps
    end
  end

  def self.down
    drop_table :stint_applications
  end
end
