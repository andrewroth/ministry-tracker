class GroupInvolvement < ActiveRecord::Base
  load_mappings
  
  belongs_to :person
  belongs_to :leader, :class_name => "Person", :foreign_key => "person_id", :conditions => "#{_(:level, :group_involvement)} = '#{Group::LEVELS.first}'"
  belongs_to :co_leader, :class_name => "Person", :foreign_key => "person_id", :conditions => "#{_(:level, :group_involvement)} = '#{Group::LEVELS.second}'"
  belongs_to :member, :class_name => "Person", :foreign_key => "person_id", :conditions => "#{_(:level, :group_involvement)} = '#{Group::LEVELS.third}' and (requested is NULL || requested = false)"
  belongs_to :interested, :class_name => "Person", :foreign_key => "person_id", :conditions => "#{_(:level, :group_involvement)} = '#{Group::LEVELS.fourth}'"
  belongs_to :requester, :class_name => "Person", :foreign_key => "person_id", :conditions => "#{_(:level, :group_involvement)} = '#{Group::LEVELS.third}' and requested = true"
  belongs_to :group
  
  validates_presence_of :group_id, :level
  
  named_scope :sorted, :joins => :person, :order => "#{_(:last_name, :person)}, #{_(:first_name, :person)}"
end
