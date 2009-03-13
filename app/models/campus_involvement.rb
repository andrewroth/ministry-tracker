class CampusInvolvement < ActiveRecord::Base
  load_mappings
  if $cache
    index _(:id)
    index _(:person_id), :order => :desc
    index [_(:person_id), _(:id)]
  end
  validates_presence_of :campus_id, :person_id, :ministry_id
  
  belongs_to :school_year
  belongs_to :campus
  belongs_to :person
  belongs_to :ministry
  belongs_to :added_by, :class_name => "Person", :foreign_key => _(:added_by_id)
end
