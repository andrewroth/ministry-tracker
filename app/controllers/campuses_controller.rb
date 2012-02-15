# Question: Doesn't seem to handle campus CRUD, but rather populates lists when
# another parameter changes. When would this be the case?

class CampusesController < ApplicationController
  before_filter :get_countries

  skip_before_filter(:login_required, :get_person, :get_ministry, :authorization_filter, :force_required_data, :set_initial_campus, :cas_filter, :cas_gateway_filter, :only => [:list, :details_json, :list_groups])
  
  def change_country
    @states = CmtGeo.states_for_country(params[:country])
  end
  
  def change_state
    @campuses = CmtGeo.campuses_for_state(params[:state], params[:country])
  end
  
  def change_county
    # TODO
    @high_schools = HighSchool.find(:all, :conditions => ["#{_(:county, :campus)} = ?", params[:county]], :order => 'name')
  end
  
  def details
    @campus = Campus.find(params[:id])
  end
  
  def list
    render :json => Campus.find(:all, :order => :campus_desc).to_json(:only => [:campus_id, :campus_desc, :campus_shortDesc])
  end
  
  def details_json
    render :json => Campus.find(params[:id])    
  end
  
  def list_groups
    sem = Month.find(:first, :conditions => {:month_calendaryear => Time.now.year, :month_number => Time.now.month}).semester
    camp = Campus.find(params[:id])
    
    render :json => camp.groups.find(:all, :conditions => {:semester_id => sem.semester_id}).collect{ |g| {
                            :name => g.name, 
                            :leaders => g.leaders.collect{ |l| {
                                                                  :fname => l.person_fname, 
                                                                  :lname => l.person_lname}
                                                               }, 
                            :time => g.meeting_day_and_time_to_string()} 
                           }.to_json
    
  end
end
