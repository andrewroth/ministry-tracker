class Team < Group
  load_mappings
  belongs_to :ministry
  belongs_to :campus
  
  validates_presence_of _(:name)
  # validates_presence_of _(:address), :message => "can't be blank"
  # validates_presence_of _(:city), :message => "can't be blank"
  # validates_presence_of _(:state), :message => "can't be blank"
  # validates_presence_of _(:country), :message => "can't be blank"
end
