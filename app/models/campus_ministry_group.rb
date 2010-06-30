class CampusMinistryGroup < ActiveRecord::Base
  belongs_to :campus
  belongs_to :ministry
  belongs_to :group
end
