class InvolvementController < ApplicationController
  layout 'people'
  
  def index
    @projects = @person.summer_projects.find(:all, :conditions => "#{_(:status, :summer_project_application)} IN ('accepted_as_participant','accepted_as_intern')")
    @prefs = []
    @person.summer_project_applications.each do |app| 
      @prefs << [app.preference1, app.preference2, app.preference3, app.preference4, app.preference5].compact 
    end
    @prefs = @prefs.flatten - @projects
    @conferences = @person.conferences.uniq 
    @stints = @person.stint_locations
  end
end
