class CreateBusyTimes < ActiveRecord::Migration
  def self.up
    create_table :busy_times do |t|
      t.integer :start_time, :end_time, :day_of_week, :timetable_id
      t.timestamps
    end
  end

  def self.down
    drop_table :busy_times
  end
end
