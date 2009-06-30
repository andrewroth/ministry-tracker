class Promotion < ActiveRecord::Base
	
	#Person to be promoted
	belongs_to :person
	#Person being asked (normally a head of a RP Tree) 
	belongs_to :promoter, :class_name => 'Person'
	belongs_to :ministry_involvement

end
