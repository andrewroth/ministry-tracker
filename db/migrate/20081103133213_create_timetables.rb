class CreateTimetables < ActiveRecord::Migration
  def self.up
    create_table :timetables do |t|
      t.integer :person_id
      t.timestamps
    end
  end

  def self.down
    drop_table :timetables
  end
end
