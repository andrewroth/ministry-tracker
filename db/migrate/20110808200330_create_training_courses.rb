class CreateTrainingCourses < ActiveRecord::Migration
  def self.up
    begin
      create_table :training_courses do |t|
        t.string :name

        t.timestamps
      end
    rescue
    end
  end

  def self.down
    begin
      drop_table :training_courses
    rescue
    end
  end
end
