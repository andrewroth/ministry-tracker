class PersonTrainingCourse < ActiveRecord::Base
  load_mappings
  
  belongs_to :person
  belongs_to :training_course
end
