class PersonTrainingCourse < ActiveRecord::Base
  
  belongs_to :person
  belongs_to :training_course
  
end
