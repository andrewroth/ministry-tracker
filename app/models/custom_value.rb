class CustomValue < ActiveRecord::Base
  load_mappings
  
  belongs_to :custom_attribute, :foreign_key => _(:custom_attribute_id)
  belongs_to :person, :foreign_key => _(:person_id)
end
