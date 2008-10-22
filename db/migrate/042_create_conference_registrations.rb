class CreateConferenceRegistrations < ActiveRecord::Migration
  def self.up
    create_table :conference_registrations do |t|
      t.integer :conference_id, :person_id
      t.timestamps
    end
  end

  def self.down
    drop_table :conference_registrations
  end
end
