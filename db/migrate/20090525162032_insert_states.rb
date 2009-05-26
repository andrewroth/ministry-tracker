class InsertStates < ActiveRecord::Migration
  STATES = [
    # USA
    [ "Alabama", "AL" ], 
    [ "Alaska", "AK" ], 
    [ "Arizona", "AZ" ], 
    [ "Arkansas", "AR" ], 
    [ "California", "CA" ], 
    [ "Colorado", "CO" ], 
    [ "Connecticut", "CT" ], 
    [ "Delaware", "DE" ], 
    [ "District Of Columbia", "DC" ], 
    [ "Florida", "FL" ], 
    [ "Georgia", "GA" ], 
    [ "Hawaii", "HI" ], 
    [ "Idaho", "ID" ], 
    [ "Illinois", "IL" ], 
    [ "Indiana", "IN" ], 
    [ "Iowa", "IA" ], 
    [ "Kansas", "KS" ], 
    [ "Kentucky", "KY" ], 
    [ "Louisiana", "LA" ], 
    [ "Maine", "ME" ], 
    [ "Maryland", "MD" ], 
    [ "Massachusetts", "MA" ], 
    [ "Michigan", "MI" ], 
    [ "Minnesota", "MN" ], 
    [ "Mississippi", "MS" ], 
    [ "Missouri", "MO" ], 
    [ "Montana", "MT" ], 
    [ "Nebraska", "NE" ], 
    [ "Nevada", "NV" ], 
    [ "New Hampshire", "NH" ], 
    [ "New Jersey", "NJ" ], 
    [ "New Mexico", "NM" ], 
    [ "New York", "NY" ], 
    [ "North Carolina", "NC" ], 
    [ "North Dakota", "ND" ], 
    [ "Ohio", "OH" ], 
    [ "Oklahoma", "OK" ], 
    [ "Oregon", "OR" ], 
    [ "Pennsylvania", "PA" ], 
    [ "Rhode Island", "RI" ], 
    [ "South Carolina", "SC" ], 
    [ "South Dakota", "SD" ], 
    [ "Tennessee", "TN" ], 
    [ "Texas", "TX" ], 
    [ "Utah", "UT" ], 
    [ "Vermont", "VT" ], 
    [ "Virginia", "VA" ], 
    [ "Washington", "WA" ], 
    [ "West Virginia", "WV" ], 
    [ "Wisconsin", "WI" ], 
    [ "Wyoming", "WY" ],
    
    # Canada
    ["Ontatio", "ON"],
    ["Quebec", "QC"],
    ["Nova Scotia", "NS"],
    ["New Brunswick", "NB"],
    ["Manitoba", "MB"],
    ["British Columbia", "BC"],
    ["Prince Edward Island", "PE"],
    ["Saskatchewan", "SK"],
    ["Alberta", "AB"],
    ["Newfoundland and Labrador", "NL"],
    ["Nothwest Territories", "NT"],
    ["Yukon", "YT"],
    ["Nunavut", "NU"]
  ]
  
  def self.up
    State.delete_all
    for s in STATES do
      State.create(:name => s[0], :abbreviation => s[1])
    end
  end

  def self.down
    State.delete_all
  end
end
