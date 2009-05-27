class AddCountryToStates < ActiveRecord::Migration
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
    ["Ontatio", "CAN"],
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
    add_column :states, :country_id, :integer
    
    # get each states country and save it
    states = State.all
    for s in states do
      for ce in STATES do
        if s.name.eql?(ce[0])
          country = Country.find_by_code(ce[1])
          s.country_id = country.id
          s.save
        end
      end
    end
    
  end

  def self.down
    remove_column :states, :country_id
  end
end
