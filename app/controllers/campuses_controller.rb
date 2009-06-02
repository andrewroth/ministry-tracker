class CampusesController < ApplicationController
  before_filter :get_countries
  
  def change_country
    @states = State.find_all_by_country_id(params[:country_id])
    @campuses = Campus.find_all_by_country_id(params[:country_id]) if @states.nil?
  end
  
  def change_state
    @campuses = Campus.find_all_by_state_id(params[:state_id])
  end
  
  def change_county
    @high_schools = HighSchool.find(:all, :conditions => ["#{_(:county, :campus)} = ?", params[:county]], :order => 'name')
  end
  
  def details
    @campus = Campus.find(params[:id])
  end
end