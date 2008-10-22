class GroupInvolvement < ActiveRecord::Base
  load_mappings
  
  belongs_to :person
  belongs_to :leader, :class_name => "Person", :foreign_key => "person_id", :conditions => "#{_(:level, :group_involvement)} = 'leader'"
  belongs_to :member, :class_name => "Person", :foreign_key => "person_id", :conditions => "#{_(:level, :group_involvement)} = 'member'"
  belongs_to :group
  belongs_to :bible_study, :foreign_key => _(:group_id)
  belongs_to :team, :foreign_key => _(:group_id)
  
  named_scope :sorted, :joins => :person, :order => "#{_(:last_name, :person)}, #{_(:first_name, :person)}"
end
