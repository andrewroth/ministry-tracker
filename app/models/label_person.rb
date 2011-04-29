class LabelPerson < ActiveRecord::Base
    load_mappings	
	
	belongs_to :person
	belongs_to :label
end
