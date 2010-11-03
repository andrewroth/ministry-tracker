class AddTimetableUpdatedByPersonIdColumn < ActiveRecord::Migration
  def self.up
    add_column Timetable.table_name, :updated_by_person_id, :integer, :default => nil
  end

  def self.down
    remove_column Timetable.table_name, Timetable._(:updated_by_person_id)
  end
end
