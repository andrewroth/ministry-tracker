class CreatePersonTrainingCourses < ActiveRecord::Migration
  def self.up
    begin
      create_table :person_training_courses do |t|
        t.integer :person_id
        t.integer :training_course_id
        t.boolean :finished
        t.integer :percent_complete

        t.timestamps
      end
      add_index PersonTrainingCourse.table_name, :person_id
      add_index PersonTrainingCourse.table_name, :training_course_id
    rescue
    end
  end

  def self.down
    begin
      remove_index PersonEventAttendee.table_name, :person_id
      remove_index PersonEventAttendee.table_name, :training_course_id
      drop_table :person_training_courses
    rescue
    end
  end
end
