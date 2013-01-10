class ContactsPerson < ActiveRecord::Base
  load_mappings

  validates_presence_of :person_id
  validates_presence_of :contact_id
end