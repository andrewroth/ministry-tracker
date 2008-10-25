class CampusInvolvement < ActiveRecord::Base
  load_mappings
  
  ROLES = ['Involved Student', 'Contact']
  
  validates_presence_of :campus_id, :person_id, :ministry_id
  validates_presence_of :ministry_role, :on => :create, :message => "can't be blank"
  
  belongs_to :campus
  belongs_to :person
  belongs_to :ministry
  belongs_to :added_by, :class_name => "Person", :foreign_key => _(:added_by_id)
end
