class InsertStateCountryAssociations < ActiveRecord::Migration
  STATES = [
    # USA
    [ "Alabama", "USA" ], 
    [ "Alaska", "USA" ], 
    [ "Arizona", "USA" ], 
    [ "Arkansas", "USA" ], 
    [ "California", "USA" ], 
    [ "Colorado", "USA" ], 
    [ "Connecticut", "USA" ], 
    [ "Delaware", "USA" ], 
    [ "District Of Columbia", "USA" ], 
    [ "Florida", "USA" ], 
    [ "Georgia", "USA" ], 
    [ "Hawaii", "USA" ], 
    [ "Idaho", "USA" ], 
    [ "Illinois", "USA" ], 
    [ "Indiana", "USA" ], 
    [ "Iowa", "USA" ], 
    [ "Kansas", "USA" ], 
    [ "Kentucky", "USA" ], 
    [ "Louisiana", "USA" ], 
    [ "Maine", "USA" ], 
    [ "Maryland", "USA" ], 
    [ "Massachusetts", "USA" ], 
    [ "Michigan", "USA" ], 
    [ "Minnesota", "USA" ], 
    [ "Mississippi", "USA" ], 
    [ "Missouri", "USA" ], 
    [ "Montana", "USA" ], 
    [ "Nebraska", "USA" ], 
    [ "Nevada", "USA" ], 
    [ "New Hampshire", "USA" ], 
    [ "New Jersey", "USA" ], 
    [ "New Mexico", "USA" ], 
    [ "New York", "USA" ], 
    [ "North Carolina", "USA" ], 
    [ "North Dakota", "USA" ], 
    [ "Ohio", "USA" ], 
    [ "Oklahoma", "USA" ], 
    [ "Oregon", "USA" ], 
    [ "Pennsylvania", "USA" ], 
    [ "Rhode Island", "USA" ], 
    [ "South Carolina", "USA" ], 
    [ "South Dakota", "USA" ], 
    [ "Tennessee", "USA" ], 
    [ "Texas", "USA" ], 
    [ "Utah", "USA" ], 
    [ "Vermont", "USA" ], 
    [ "Virginia", "USA" ], 
    [ "Washington", "USA" ], 
    [ "West Virginia", "USA" ], 
    [ "Wisconsin", "USA" ], 
    [ "Wyoming", "USA" ],
    
    # Canada
    ["Ontario", "CAN"],
    ["Quebec", "CAN"],
    ["Nova Scotia", "CAN"],
    ["New Brunswick", "CAN"],
    ["Manitoba", "CAN"],
    ["British Columbia", "CAN"],
    ["Prince Edward Island", "CAN"],
    ["Saskatchewan", "CAN"],
    ["Alberta", "CAN"],
    ["Newfoundland and Labrador", "CAN"],
    ["Nothwest Territories", "CAN"],
    ["Yukon", "CAN"],
    ["Nunavut", "CAN"]
  ]
  
  def self.up
    # reset all state-country associations
    State.all.each { |s| s.country_id = nil; s.save }
    
    # flip em around so we can rassoc them
    lookup_states = STATES.map { |s| [s[1], s[0]]}
    
    to_save = []
    
    # get each states country
    for s in State.all
      country_code = lookup_states.rassoc(s.name)
      country = Country.find_by_code(country_code)
      s.country_id = country.id
      to_save << s
    end
    
    # save each state's country
    to_save.each {|s| s.save }
  end

  def self.down
    # reset all state-country associations
    State.all.each { |s| s.country_id = nil; s.save }
  end
end
