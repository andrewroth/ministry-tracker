class GlobalDashboardController < ApplicationController
  ALLOWED_GUIDS = [
    "250F5FAB-E473-36D8-D406-DFB1C00DD1F2",
    "556CD6D6-1C80-3F12-C288-F8F62E0BEB55",
    "109EFFA5-C99F-4429-88D8-2B4DB0143B7F",
    "2F093DB0-7ED2-CF56-BBAA-2F3D5DAF8D4A",
    "C37B7FEA-1091-84C5-FA82-64F70A26814C",
    "C7634543-62CB-A3F2-934A-9389E786D454",
    "F6874A2D-C08F-DFE7-7763-5664B8E56621",
    "33910AAE-5EE5-ED88-23A2-36FF4509F107",
    "80B0D053-3A82-8D0C-0A17-3DC64421DDF6",
    "2BAE7844-59E4-39F7-7A4D-B02450289513",
    "999D463E-AC3D-34E8-B18C-45D153DF5545"
  ]

  before_filter :ensure_permission
  skip_before_filter :authorization_filter

  def index
    @area = true
    setup
    setup_stats(GlobalArea.all, all_mccs)
  end

  def update_stats
    case params[:l]
    when "all"
      location_filter_arr = GlobalArea.all
      @area = true
    when /a_(.*)/
      location_filter_arr = [ GlobalArea.find $1 ]
      @area = true
    when /c_(.*)/
      location_filter_arr = [ GlobalCountry.find $1 ]
      @area = false
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
      }.flatten.compact

      if area_filters.length == 1 && area_filters.first.is_a?(GlobalCountry)
        country = area_filters.first
        @country_name = country.name
        @country_stage = country.stage
        @country_funding = country.locally_funded_FY10
        @country_area = country.global_area.area
      elsif area_filters.length == 1 && area_filters.first.is_a?(GlobalArea)
        area = area_filters.first
        @country_area = area.area
      elsif params["l"] == "all" || params[:action] == "index"
        @country_area = "All"
      end

      @genders = { "male" => 0, "female" => 0, "" => 0 }
      @marital_status = {}
      @languages = {}
      @mccs = {}
      @funding_source = {}
      @staff_status = {}
      @position = {}
      @scope = {}
      @gcx_profile_count = {}
      @profiles = GlobalProfile.all
      @profiles.each do |profile|
        if (filters_isos.include?(profile.ministry_location_country) || 
           filters_isos.include?(profile.employment_country)) &&
          mcc_filters.include?(profile.mission_critical_components)
          @genders[profile.gender] += 1 if profile.gender
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
          @gcx_profile_count["total"] ||= 0
          @gcx_profile_count["total"] += 1
          if filters_isos.include?(profile.ministry_location_country)
            @gcx_profile_count["serving_here"] ||= 0
            @gcx_profile_count["serving_here"] += 1
          end
          if filters_isos.include?(profile.employment_country)
            @gcx_profile_count["employed_here"] ||= 0
            @gcx_profile_count["employed_here"] += 1
          end
        end
      end

      @stage = {}
      GlobalCountry.all(:order => "name").each do |country|
        if filters_isos.include?(country.iso3)
          stage = country.stage
          @stage[stage] ||= 0
          @stage[stage] += 1
          @stage["countries"] ||= []
          @stage["countries"] << { country.name => country.stage }
        end
      end

      @whq = ActiveSupport::OrderedHash.new
      GlobalCountry.all.each do |country|
        if filters_isos.include?(country.iso3)
          %w(live_exp live_dec new_grth_mbr mvmt_mbr mvmt_ldr new_staff lifetime_lab).each do |stat|
            @whq[stat] ||= 0
            @whq[stat] += country.send(stat).to_i
          end
        end
      end

      @demog = ActiveSupport::OrderedHash.new
      @demog_avg_total = ActiveSupport::OrderedHash.new
      @demog_avg_n = ActiveSupport::OrderedHash.new
      GlobalCountry.all.each do |country|
        if filters_isos.include?(country.iso3)
          %w(pop_2010 pop_2015 pop_2020 pop_wfb_gdppp).each do |stat|
            @demog[stat] ||= 0
            @demog[stat] += country.send(stat).to_i
          end
          %w(perc_christian perc_evangelical).each do |stat|
            @demog_avg_n[stat] ||= 0
            @demog_avg_n[stat] += 1
            @demog_avg_total[stat] ||= 0.0
            @demog_avg_total[stat] += country.send(stat).to_f
          end
          %w(perc_christian perc_evangelical).each do |stat|
            @demog[stat] = @demog_avg_total[stat] / @demog_avg_n[stat].to_f
          end
        end
      end

      @fiscal = ActiveSupport::OrderedHash.new
      @fiscal_avg_total = ActiveSupport::OrderedHash.new
      @fiscal_avg_n = ActiveSupport::OrderedHash.new
      GlobalCountry.all.each do |country|
        if filters_isos.include?(country.iso3)
          %w(total_income_FY10).each do |stat|
            @fiscal[stat] ||= 0
            @fiscal[stat] += country.send(stat).to_i
          end
          %w(locally_funded_FY10).each do |stat|
            @fiscal_avg_n[stat] ||= 0
            @fiscal_avg_n[stat] += 1
            @fiscal_avg_total[stat] ||= 0.0
            @fiscal_avg_total[stat] += country.send(stat).to_f
          end
          %w(locally_funded_FY10).each do |stat|
            @fiscal[stat] = @fiscal_avg_total[stat] / @fiscal_avg_n[stat].to_f
          end
        end
      end

      @staff_counts = ActiveSupport::OrderedHash.new
      GlobalCountry.all.each do |country|
        if filters_isos.include?(country.iso3)
          %w(staff_count_2002 staff_count_2009).each do |stat|
            @staff_counts[stat] ||= 0
            @staff_counts[stat] += country.send(stat).to_i
          end
          @staff_counts["difference"] = @staff_counts["staff_count_2009"] - @staff_counts["staff_count_2002"]
        end
      end

      @schools = ActiveSupport::OrderedHash.new
      @names_priority_spcs = []
      GlobalCountry.all.each do |country|
        if filters_isos.include?(country.iso3)
          %w(total_students total_schools total_spcs).each do |stat|
            @schools[stat] ||= 0
            @schools[stat] += country.send(stat).to_i
          end
          @names_priority_spcs << country.names_priority_spcs
        end
      end
      @names_priority_spcs = @names_priority_spcs.compact.delete_if{ |s| s == "" }.join(", ")

      @slm = ActiveSupport::OrderedHash.new
      GlobalCountry.all.each do |country|
        if filters_isos.include?(country.iso3)
          %w(total_spcs_presence total_spcs_movement total_slm_staff total_new_slm_staff).each do |stat|
            @slm[stat] ||= 0
            @slm[stat] += country.send(stat).to_i
          end
        end
      end
    end

    def ensure_permission
      access_denied unless [283, 5173].include?(@person.id) || 
        ALLOWED_GUIDS.include?(@person.try(:user).try(:guid))
    end

    def all_mccs
      @all_mccs ||= GlobalProfile.all.collect(&:mission_critical_components).uniq.compact.sort
    end

    def all_mcc_options
      @all_mcc_options ||= all_mccs.collect{ |mcc|
        mcc == "" ? "No mcc chosen" : mcc
      }
    end
end
