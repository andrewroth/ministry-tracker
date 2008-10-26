class MinistryInvolvement < ActiveRecord::Base
  load_mappings
  
  ROLES = ['Director','Staff','Student Leader']
  
  belongs_to :person, :class_name => "Person", :foreign_key => _(:person_id)
  belongs_to :ministry
  
  validates_presence_of _(:ministry_role), :on => :create, :message => "can't be blank"
end
