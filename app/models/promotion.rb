class Promotion < ActiveRecord::Base
	
	#Person to be promoted
	belongs_to :person
	#Person being asked (normally a head of a RP Tree) 
	belongs_to :promoter, :class_name => "Person"
	belongs_to :ministry_involvement
	has_one :responsible_person, :class_name => "Person", :through => :ministry_involvement, :foreign_key => :responsible_person_id
	
end
