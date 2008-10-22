class CampusesController < ApplicationController
  before_filter :get_countries
  
  def change_country
    @states = State::NAMES[params[:country]]
    @colleges = College.find(:all, :conditions => ["#{_(:country, :campus)} = ?", params[:country]], :order => 'name') if @states.nil? 
  end
  
  def change_state
    @colleges = College.find(:all, :conditions => ["#{_(:state, :campus)} = ?", params[:state]], :order => 'name')
    @counties = County.find(:all, :conditions => ["#{_(:state, :campus)} = ?", params[:state]], :order => 'name')
  end
  
  def change_county
    @high_schools = HighSchool.find(:all, :conditions => ["#{_(:county, :campus)} = ?", params[:county]], :order => 'name')
  end
  
  def details
    @campus = Campus.find(params[:id])
  end
end