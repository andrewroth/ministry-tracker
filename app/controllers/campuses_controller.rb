# Question: Doesn't seem to handle campus CRUD, but rather populates lists when
# another parameter changes. When would this be the case?

class CampusesController < ApplicationController
  before_filter :get_countries
  
  def change_country
    @states = CmtGeo.states_for_country(params[:country])
    @campuses = @states.collect{ |state| CmtGeo.campuses_for_state(state, params[:country]) }
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
end
