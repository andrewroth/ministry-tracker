class CreateTimetablesIndexOnPersonid < ActiveRecord::Migration
  def self.up
    add_index Timetable.table_name, Timetable._(:person_id)
  end

  def self.down
    remove_index Timetable.table_name, Timetable._(:person_id)
  end
end
