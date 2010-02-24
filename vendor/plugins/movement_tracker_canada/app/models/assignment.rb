class Assignment < ActiveRecord::Base
  unloadable
  load_mappings

  belongs_to :assignmentstatus
  belongs_to :person
  belongs_to :campus
end
