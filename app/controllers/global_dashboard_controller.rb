class GlobalDashboardController < ApplicationController
  before_filter :ensure_permission

  def index
    setup
    setup_stats(GlobalArea.all, all_mccs)
  end

  def update_stats
    case params[:l]
    when "all"
      location_filter_arr = GlobalArea.all
    when /a_(.*)/
      location_filter_arr = [ GlobalArea.find $1 ]
    when /c_(.*)/
      location_filter_arr = [ GlobalCountry.find $1 ]
    end

    case params[:mcc]
    when "all"
      mcc_filters = all_mccs
    else
      mcc_filters = [ params[:mcc] ]
    end

    @no_filter = location_filter_arr.nil?
    setup
    setup_stats(location_filter_arr, mcc_filters) unless @no_filter
  end

  protected

    def setup
      @grouped_options = [ [ "All", [ [ "All", "all" ] ] ] ]
      @grouped_options << [ "Areas", GlobalArea.all.collect{ |ga| [ ga.area, "a_#{ga.id}" ] } ]
      GlobalArea.all(:order => "area").each do |global_area|
        @grouped_options << [ global_area.area, 
          global_area.global_countries.collect{ |gc| [ 
            gc.name == "" ? "No country chosen" : gc.name, "c_#{gc.id}" 
        ] }
        ]
      end

      @mcc_options = [["All", "all"]] + all_mcc_options
    end

    def setup_stats(area_filters, mcc_filters)
      filters_isos = area_filters.collect { |f|
        f.isos
      }.flatten

      @genders = { "male" => 0, "female" => 0, "" => 0 }
      @marital_status = {}
      @languages = {}
      @mccs = {}
      @funding_source = {}
      @staff_status = {}
      @position = {}
      @scope = {}
      @profiles = GlobalProfile.all
      @profiles.each do |profile|
        if filters_isos.include?(profile.ministry_location_country) &&
          mcc_filters.include?(profile.mission_critical_components)
          @genders[profile.gender] += 1
          @marital_status[profile.marital_status] ||= 0
          @marital_status[profile.marital_status] += 1
          @languages[profile.language] ||= 0
          @languages[profile.language] += 1
          @mccs[profile.mission_critical_components] ||= 0
          @mccs[profile.mission_critical_components] += 1
          @funding_source[profile.funding_source] ||= 0
          @funding_source[profile.funding_source] += 1
          @staff_status[profile.staff_status] ||= 0
          @staff_status[profile.staff_status] += 1
          @position[profile.position] ||= 0
          @position[profile.position] += 1
          @scope[profile.scope] ||= 0
          @scope[profile.scope] += 1
        end
      end
    end

    def ensure_permission
      access_denied unless [283, 5173].include?(@person.id)
    end

    def all_mccs
      @all_mccs ||= GlobalProfile.all.collect(&:mission_critical_components).uniq.sort
    end

    def all_mcc_options
      @all_mcc_options ||= all_mccs.collect{ |mcc|
        mcc == "" ? "No mcc chosen" : mcc
      }
    end
end
