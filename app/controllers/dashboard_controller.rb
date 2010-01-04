# Provides the following information:
# * Count of people in ministry
# * movement count (definition unclear)
# * names of newest people added
class DashboardController < ApplicationController
  
  def index
    @people_in_ministries = MinistryInvolvement.count(:conditions => ["#{_(:ministry_id, :ministry_involvement)} IN(?)", @ministry.id ])
    @movement_count = @my.ministry_involvements.length
  
    @ministry_ids ||= @my.ministry_involvements.collect(&:ministry_id).join(',')
      
    get_person_campus_groups

    if  @ministry_ids.present? #&& @ministry.campus_ids.present? 
       @newest_people = Person.find(:all, :conditions => "#{MinistryInvolvement.table_name}." + _(:ministry_id, :ministry_involvement) + " IN (#{@ministry_ids})", # OR #{CampusInvolvement.table_name}.#{_(:campus_id, :campus_involvement)} IN (#{@ministry.campus_ids.join(',')})
                                         :order => "#{Person.table_name}.#{_(:created_at, :person)} desc", :limit => 4, :include => [:ministry_involvements, :campus_involvements])
                                                                           
    end    
  end
  
end
