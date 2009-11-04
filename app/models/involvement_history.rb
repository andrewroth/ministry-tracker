class InvolvementHistory < ActiveRecord::Base
  load_mappings
  belongs_to :person
  belongs_to :campus
  belongs_to :ministry_role
  belongs_to :school_year
  belongs_to :ministry
end
