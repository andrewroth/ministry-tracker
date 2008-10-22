class ConferenceRegistration < ActiveRecord::Base
  load_mappings
  belongs_to :conference, :class_name => "Conference", :foreign_key => _(:conference_id)
  belongs_to :person, :class_name => "Person", :foreign_key => _(:person_id)
end
