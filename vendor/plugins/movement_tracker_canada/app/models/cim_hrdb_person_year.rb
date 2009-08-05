class CimHrdbPersonYear < ActiveRecord::Base
  load_mappings
  belongs_to :person
  belongs_to :school_year, :foreign_key => 'year_id'
end
