# Question: Doesn't seem to handle campus CRUD, but rather populates lists when
# another parameter changes. When would this be the case?

class CampusesController < ApplicationController
  before_filter :get_countries

  skip_before_filter(:login_required, :get_person, :get_ministry, :authorization_filter, :force_required_data, :set_initial_campus, :cas_filter, :cas_gateway_filter, :only => [:list])
  
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
    render :json => Campus.all
  end
end
