class Person < ActiveRecord::Base
  load_mappings
  include Common::Person

  # Summer Projects
  has_many :summer_project_applications, :order =>  "#{SummerProjectApplication.table_name}.#{_(:created_at, :summer_project_application)}"
  has_many :summer_projects, :through => :summer_project_applications, :order => "#{SummerProject.table_name}.#{_(:created_at, :summer_project)} desc"
end
