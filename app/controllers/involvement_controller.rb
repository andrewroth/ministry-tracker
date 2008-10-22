class InvolvementController < ApplicationController
  layout 'people'
  
  def index
    @projects = @person.summer_projects.find(:all, :conditions => "#{_(:status, :summer_project_application)} IN ('accepted_as_participant','accepted_as_intern')")
    @conferences = @person.conferences
    @stints = @person.stint_locations
  end
end
