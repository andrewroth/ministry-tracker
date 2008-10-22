class SummerProjectApplication < ActiveRecord::Base
  load_mappings
  belongs_to :person, :class_name => "Person", :foreign_key => _(:person_id, :person)
  belongs_to :summer_project, :class_name => "SummerProject", :foreign_key => _(:summer_project_id, :summer_project_application)
end
