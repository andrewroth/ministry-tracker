class LabelPerson < ActiveRecord::Base
  load_mappings
	
	belongs_to :person, :foreign_key => _(:person_id)
	belongs_to :label, :foreign_key => _(:label_id)
end
