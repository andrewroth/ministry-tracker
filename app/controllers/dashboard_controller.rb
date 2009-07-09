class DashboardController < ApplicationController
  
  def index
    @people_in_ministries = MinistryInvolvement.count(:conditions => ["#{_(:ministry_id, :ministry_involvement)} IN(?)", @my.ministries.collect(&:id)])
    @movement_count = @my.ministry_involvements.count
  
    @ministry_ids ||= @my.ministry_involvements.collect(&:ministry_id).join(',')
      
    if @ministry.campus_ids.present?
      @newest_people = Person.find(:all, :conditions => "#{MinistryInvolvement.table_name}." + _(:ministry_id, :ministry_involvement) + " IN (#{@ministry_ids}) OR #{CampusInvolvement.table_name}.#{_(:campus_id, :campus_involvement)} IN (#{@ministry.campus_ids.join(',')})",
                                         :order => "#{Person.table_name}.#{_(:created_at, :person)} desc", :limit => 4, :include => [:ministry_involvements, :campus_involvements])
    end    
  end
  
end
