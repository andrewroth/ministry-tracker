class TrainingCourse < ActiveRecord::Base
  has_many :person_training_courses
end
