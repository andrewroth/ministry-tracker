class StatsController < ApplicationController
  unloadable
  
  def index
    
    @national_access = authorized?(:how_people_prayed_to_receive_christ, :national_team) ? true : false
    @regional_access = authorized?(:summary_by_week, :regional_team) ? true : false
    @campusdirector_access = authorized?(:monthly_summary_by_campus, :campus_directors) ? true : false
    @allstaff_access = authorized?(:year_summary, :all_staff) ? true : false
    
  end
end
