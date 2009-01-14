class SummerProjectApplication < ActiveRecord::Base
  load_mappings
  belongs_to :person, :class_name => "Person", :foreign_key => _(:person_id, :person)
  belongs_to :summer_project, :class_name => "SummerProject", :foreign_key => _(:summer_project_id, :summer_project_application)
  belongs_to :preference1, :class_name => "SummerProject", :foreign_key => _(:preference1_id, :summer_project_application)
  belongs_to :preference2, :class_name => "SummerProject", :foreign_key => _(:preference2_id, :summer_project_application)
  belongs_to :preference3, :class_name => "SummerProject", :foreign_key => _(:preference3_id, :summer_project_application)
  belongs_to :preference4, :class_name => "SummerProject", :foreign_key => _(:preference4_id, :summer_project_application)
  belongs_to :preference5, :class_name => "SummerProject", :foreign_key => _(:preference5_id, :summer_project_application)
end
