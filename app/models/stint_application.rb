class StintApplication < ActiveRecord::Base
  load_mappings
  belongs_to :person, :class_name => "Person", :foreign_key => _(:person_id)
  belongs_to :stint_location, :class_name => "StintLocation", :foreign_key => _(:stint_location_id)
end
