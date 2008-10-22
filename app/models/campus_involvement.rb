class CampusInvolvement < ActiveRecord::Base
  load_mappings
  
  belongs_to :campus
  belongs_to :person
  belongs_to :ministry
end
