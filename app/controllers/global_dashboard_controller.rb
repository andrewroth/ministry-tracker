class GlobalDashboardController < ApplicationController
  before_filter :ensure_permission

  def index
    setup
    setup_stats(GlobalArea.all)
  end

  def update_stats
    f = params.keys.first
    if f =~ /a_(.*)/
      fo = GlobalArea.find $1
    elsif f =~ /c_(.*)/
      fo = GlobalCountry.find $1
    end
    @no_filter = fo.nil?
    setup
    setup_stats([fo]) unless @no_filter
  end

  protected

    def setup
      @grouped_options = [ [ "All", [ "all" ] ] ]
      @grouped_options << [ "Areas", GlobalArea.all.collect{ |ga| [ ga.area, "a_#{ga.id}" ] } ]
      GlobalArea.all(:order => "area").each do |global_area|
        @grouped_options << [ global_area.area, 
          global_area.global_countries.collect{ |gc| [ gc.name, "c_#{gc.id}" ] } ]
      end
    end

    def setup_stats(filters)
      filters_isos = filters.collect { |f|
        f.isos
      }.flatten

      @genders = { "male" => 0, "female" => 0, "" => 0 }
      @profiles = GlobalProfile.all
      @profiles.each do |profile|
        if filters_isos.include?(profile.ministry_location_country)
          @genders[profile.gender] += 1
        end
      end
    end

    def ensure_permission
      access_denied unless [283, 5173].include?(@person.id)
    end
end
