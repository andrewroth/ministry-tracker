class SummerProject < ActiveRecord::Base
  load_mappings
  has_many :summer_project_applications, :class_name => "SummerProjectApplication", :foreign_key => _(:summer_project_id, :summer_project_application)
  has_many :people, :through => :summer_project_applications
end
