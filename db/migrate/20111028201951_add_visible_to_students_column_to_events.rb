class AddVisibleToStudentsColumnToEvents < ActiveRecord::Migration
  def self.up
    begin
      add_column Event.table_name, :visible_to_students, :boolean
      Event.all.each {|e| e.visible_to_students = true; e.save }
    rescue
    end
  end

  def self.down
    begin
      remove_column Event.table_name, :visible_to_students
    rescue
    end
  end
end
