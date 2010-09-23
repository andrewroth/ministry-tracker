class CampusMinistryGroup < ActiveRecord::Base
  load_mappings
  belongs_to :campus
  belongs_to :ministry
  belongs_to :group
end
