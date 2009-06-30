class Promotion < ActiveRecord::Base

	belongs_to :person
	belongs_to :promoter, :class_name => 'Person'
	belongs_to :ministry_involvement
	belongs_to :promotee, :class_name => 'Person', :through => :ministry_involvement, :foreign_key => _(:person_id, :ministry_involvement)


end
