class MinistryInvolvement < ActiveRecord::Base
  load_mappings
  
  if $cache
    index _(:id)
    index _(:person_id)
  end
  
  belongs_to :responsible_person, :class_name => "Person"
  belongs_to :person, :class_name => "Person", :foreign_key => _(:person_id)
  belongs_to :ministry
  belongs_to :ministry_role, :class_name => "MinistryRole", :foreign_key => _("ministry_role_id")
  has_many :permissions, :through => :ministry_role, :source => :ministry_role_permissions
  has_one :promotion
    
  validates_presence_of _(:ministry_role_id), :on => :create, :message => "can't be blank"

end
