class CampusInvolvement < ActiveRecord::Base
  load_mappings
  validates_presence_of :campus_id, :person_id, :ministry_id, :school_year_id
  validates_uniqueness_of _(:end_date), :scope => [ _(:campus_id), _(:person_id), 
    _(:school_year_id) ], :message => 'is invalid.  You already have a campus involvement with this school year; edit that campus involvement instead.'

  belongs_to :school_year
  belongs_to :campus
  belongs_to :person
  belongs_to :ministry
  belongs_to :added_by, :class_name => "Person", :foreign_key => _(:added_by_id)
end
