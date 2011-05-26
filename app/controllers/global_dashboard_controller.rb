class GlobalDashboardController < ApplicationController

  ALLOWED_GUIDS = [ # TODO: this will be removed once data is imported to GlobalDashboardAccess rows
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
  before_filter :set_can_edit_stages
  skip_before_filter :authorization_filter

  def index
    @area = true
    setup
    setup_stats(GlobalArea.all, all_mccs)
  end

  def staging_summary
    @areas = GlobalArea.all(:order => :area, :include => :global_countries)
    @stage_count = { }
    @totals = { }
    @areas.each do |area|
      area.global_countries.each do |country|
        if stage = country.stage
          @stage_count[area] ||= {}
          @stage_count[area][stage] ||= 0
          @stage_count[area][stage] += 1
          @totals[stage] ||= 0
          @totals[stage] += 1
        end
      end
    end

    respond_to do |format|
      format.html
      format.csv {
        csv_out = ""
        CSV::Writer.generate(csv_out) do |csv|
          csv << [ "", "Stage 1", "Stage 2", "Stage 3" ]
          @areas.each do |area|
            csv << [ area.area, @stage_count[area][1], @stage_count[area][2], @stage_count[area][3] ]
          end
          csv << [ "total", @totals[1], @totals[2], @totals[3] ]
        end
        send_data(csv_out,
                  :type => 'text/csv; charset=utf-8; header=present',
                  :filename => "staging_summary_export.csv")
      }
    end
  end

  def staging_breakdown
    @rows = []
    areas = GlobalArea.all(:order => :area, :include => :global_countries)
    areas.each do |area|
      area.global_countries.each do |gc|
        @rows << [ area.area, gc.name, gc.stage ]
      end
    end

    respond_to do |format|
      format.html
      format.csv {
        csv_out = ""
        CSV::Writer.generate(csv_out) do |csv|
          csv << [ "Area", "Country", "Stage" ]
          @rows.each do |row|
            csv << row
          end
        end
        send_data(csv_out,
                  :type => 'text/csv; charset=utf-8; header=present',
                  :filename => "staging_breakdown_export.csv")
      }
    end
  end

  def export
    case params[:location]
    when "all"
      countries = GlobalArea.all.collect(&:global_countries).flatten
      @area = true
    when /a_(.*)/
      countries = GlobalArea.find($1).global_countries
      @area = true
    when /c_(.*)/
      countries = [ GlobalCountry.find $1 ]
      @area = false
    end

    case params[:mcc]
    when "all"
      mcc_filters = all_mccs
    else
      mcc_filters = [ params[:mcc] ]
    end

    country_column_names_to_strings = {
      "name" => 'Name',
      "iso3" => 'Iso',
      "stage" => 'Stage',
      "live_exp" => 'Live Exposures',
      "live_dec" => 'Live Decisions',
      "new_grth_mbr" => 'New Growth Group Members',
      "mvmt_mbr" => 'Movement Members',
      "mvmt_ldr" => 'Movement Leaders',
      "new_staff" => 'New Staff',
      "lifetime_lab" => 'Lifetime Labourers',
      "pop_2010" => 'Pop 2010',
      "pop_2015" => 'Pop 2015',
      "pop_2020" => 'Pop 2020',
      "pop_wfb_gdppp" => 'Pop WFB GDP',
      "perc_christian" => 'Perc Christian',
      "perc_evangelical" => 'Perc Evangelical',
      "locally_funded_FY10" => '% Locally Funded in FY10',
      "total_income_FY10" => 'Total Income in FY10',
      "staff_count_2002" => 'Staff Count 2002',
      "staff_count_2009" => 'Staff Count 2009',
      "total_students" => 'Total Students',
      "total_schools" => 'Total Schools',
      "total_spcs" => 'Total Student Population Centers (SPCs)',
      "names_priority_spcs" => 'Names of Priority SPCs',
      "total_spcs_presence" => 'Total SPCs with presence',
      "total_spcs_movement" => 'Total SPCs with movement',
      "total_slm_staff" => 'Total SLM Staff',
      "total_new_slm_staff" => "Total New Staff 2009-2010",
      "serving_here" => "Serving Here",
      "employed_here_serving_here" => "Employed Here Serving Here",
      "employed_here_serving_elsewhere" => "Employed Here Serving Elsewhere"
    }
    columns = [ "name", "iso3", "stage", "live_exp", "live_dec", "new_grth_mbr", "mvmt_mbr", "mvmt_ldr", "new_staff", "lifetime_lab", "pop_2010", "pop_2015", "pop_2020", "pop_wfb_gdppp", "perc_christian", "perc_evangelical", "locally_funded_FY10", "total_income_FY10", "staff_count_2002", "staff_count_2009", "total_students", "total_schools", "total_spcs", "names_priority_spcs", "total_spcs_presence", "total_spcs_movement", "total_slm_staff", "total_new_slm_staff", "serving_here", "employed_here_serving_here", "employed_here_serving_elsewhere" ]
    instance_vars_to_export = %w(genders marital_status mccs staff_status funding_source position scope)
    #outfile = File.open('csvout', 'wb')
    csv_out = ""
    CSV::Writer.generate(csv_out) do |csv|
=begin
      csv << [ "Country Name", "Area", "% Local Funding", "Fiscal 2010 Income", "Staff Count 2002", 
        "Staff Count 2009", "02-09 Difference", "GCX Profile - Serving Here", 
        "GCX Profile - Employed Here, Serving Here", "GCX Profile - Employed Here, Serving Elsewhere", 
        "Live Exposures", "Live Decisions", "New Growth Group Members", "Movement Members",
        "New Staff", "Lifetime Labourers", "Total # Univ & College Students", "Total # Univ & College Inst",
        "# Student Pop Centers", "SPCs w/ any ministry or movement activity or CCC presence",
        "SPCs with movements", "Total # SLM Staff (of any nationality serving in the country)",
        "New National SLM staff joining 2009-2010 academic year", "Pop2010", "Pop2015", "Pop2020",
        "WFB_GDPPP", "PercChristian", "PercEvangelical" ]
=end
      setup_stats([ GlobalCountry.first ], mcc_filters) # to get the instance var hashes set
      csv << columns.collect{ |c| country_column_names_to_strings[c] } #+ 
      #  instance_vars_to_export.collect{ |v|
      #    h = eval("@#{v}")
      #    h.keys.collect{ |k| k == nil ? "#{v}_no_value" : "#{v}_#{k}" }
      #  }.flatten
      #throw instance_vars_to_export.collect{ |v| h = eval("@#{v}"); h.keys.collect{ |k| k == nil || k == "" ? "#{v}_no_value" : "#{v}_#{k}" }; }.flatten

      for c in countries
        #setup_stats([c], mcc_filters)
        csv << columns.collect{ |col| c.send(col) } #+ 
#          instance_vars_to_export.collect{ |v|
#            h = eval("@#{v}")
#            h.values
#          }.flatten
      end
    end

    #outfile.close
    send_data(csv_out,
              :type => 'text/csv; charset=utf-8; header=present',
              :filename => "export.csv")

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

  def submit_whq
    if request.post?
      @gd = GlobalDashboardWhqStat.find_or_create_by_mcc_and_month_id_and_global_country_id(params[:whq_stat][:mcc], 
                                                                                  params[:whq_stat][:month_id], 
                                                                                  params[:whq_stat][:global_country_id])
      @gd.update_attributes(params[:gd])
      @whq_message = "WHQ Data saved."
      redirect_to :action => :index
      return
    end

    setup
    @mcc_options = all_mccs
    @country_options = GlobalCountry.all.collect{ |gc| [ gc.name, gc.id ] }
  end

  def update_whq_submit_fields
    unless params[:mcc].present?
      @whq_message = "Choose an MCC."
      return
    end
    unless params[:m].present?
      @whq_message = "Choose a month."
      return
    end
    unless params[:c].present?
      @whq_message = "Choose a country."
      return
    end
    @gd = GlobalDashboardWhqStat.find_by_mcc_and_month_id_and_global_country_id(params[:mcc], 
                                                                               params[:m], params[:c])
    if @gd.nil? 
      @whq_message = "No data for that period currently."
      @gd = GlobalDashboardWhqStat.new
    else
      @whq_message = "Existing data found."
    end
  end

  def submission_status_report
    if request.xhr?
      @areas_present = {}
      @areas_total = {}
      stage = params[:s]
      #area_find = params[:a].present? ? params[:a] : :all
      GlobalArea.find(:all, :include => { :global_countries => :global_dashboard_whq_stats }).each do |ga|
        ga.global_countries.each do |gc|
          @areas_present[ga] ||= 0
          @areas_total[ga] ||= 0
          if (stage == "all" || gc.stage.to_s == stage) && 
            gc.global_dashboard_whq_stats.find_by_mcc_and_month_id(params[:mcc], params[:m]).present?
          #if gc.global_dashboard_whq_stats.find_all_by_mcc(params[:mcc]).present?
            @areas_present[ga] += 1
          end
          @areas_total[ga] += 1
        end
      end
    end
    setup
    @mcc_options = all_mccs
    @area_options = GlobalArea.all.collect{ |ga| [ ga.area, ga.id ] }
    @stage_options = [ [ "Any Stage", "all" ], [ "Stage 1", 1], [ "Stage 2", 2], [ "Stage 3", 3 ] ]
  end

  def submission_area_report

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
      @month_options = Month.all.collect{ |m| [ m.month_desc, m.month_id ] }
    end

    def setup_stats(area_filters, mcc_filters)
      filters_isos = area_filters.collect { |f|
        f.isos
      }.flatten.compact

      if area_filters.length == 1 && area_filters.first.is_a?(GlobalCountry)
        @country = country = area_filters.first
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

      isos_to_country_name = Hash[GlobalCountry.all.collect{ |c| [ c.iso3, c.name ] }]
      @genders = { "male" => 0, "female" => 0, "" => 0 }
      @marital_status = {}
      @languages = {}
      @mccs = {}
      @funding_source = {}
      @staff_status = {}
      @position = {}
      @scope = {}
      @gcx_profile_count = {}
      @serving_here_employed_elsewhere = {}
      @employed_here_serving_elsewhere = {}
      @profiles = GlobalProfile.all
      @gcx_profile_count["serving_here"] = 0
      @gcx_profile_count["employed_here_serving_elsewhere"] = 0
      @gcx_profile_count["employed_here_serving_here"] = 0
      @profiles.each do |profile|
        if (filters_isos.include?(profile.ministry_location_country) || 
           filters_isos.include?(profile.employment_country)) &&
          mcc_filters.include?(profile.mission_critical_components)
          if filters_isos.include?(profile.ministry_location_country)
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
          end
          if filters_isos.include?(profile.ministry_location_country)
            @gcx_profile_count["serving_here"] += 1
            #if !filters_isos.include?(profile.employment_country)
              # serving here, from elsewhere
              k = profile.employment_country.present? ? isos_to_country_name[profile.employment_country] : "Volunteer"
              @serving_here_employed_elsewhere[k] ||= 0
              @serving_here_employed_elsewhere[k] += 1
            #end
          end
          if filters_isos.include?(profile.employment_country)
            if filters_isos.include?(profile.ministry_location_country)
              @gcx_profile_count["employed_here_serving_here"] += 1
            else
              k = profile.ministry_location_country.present? ? isos_to_country_name[profile.ministry_location_country] : "No value entered"
              @employed_here_serving_elsewhere[k] ||= 0
              @employed_here_serving_elsewhere[k] += 1
              @gcx_profile_count["employed_here_serving_elsewhere"] += 1
            end
          end
        end
      end

      @stage = {}
      @stage["countries_with_stage"] ||= []
      @stage["countries_no_stage"] ||= []
      GlobalCountry.all(:order => "name").each do |country|
        if filters_isos.include?(country.iso3)
          stage = country.stage
          @stage[stage] ||= 0
          @stage[stage] += 1
          if country.stage.nil? || country.stage == ""
            @stage["countries_no_stage"] << country.name
          else
            @stage["countries_with_stage"] << { country.name => country.stage }
          end
        end
      end

      @whq = ActiveSupport::OrderedHash.new
      GlobalCountry.all.each do |country|
        if filters_isos.include?(country.iso3)
          GlobalCountry::WHQ_MCCS.each do |whq_mcc|
            if mcc_filters.include?(GlobalCountry::WHQ_MCCS_TO_PARAMS[whq_mcc])
              %w(live_exp live_dec new_grth_mbr mvmt_mbr mvmt_ldr new_staff lifetime_lab).each do |stat|
                @whq[stat] ||= 0
                @whq[stat] += country.send("#{whq_mcc}_#{stat}").to_i
              end
            end
          end
        end
      end

      @demog = ActiveSupport::OrderedHash.new
      @demog_avg_total = ActiveSupport::OrderedHash.new
      @demog_avg_n = ActiveSupport::OrderedHash.new
      GlobalCountry.all.each do |country|
        if filters_isos.include?(country.iso3)
          %w(pop_2010 pop_2015 pop_2020).each do |stat|
            @demog[stat] ||= 0
            @demog[stat] += country.send(stat).to_i
          end
          %w(perc_christian perc_evangelical pop_wfb_gdppp).each do |stat|
            if country.send(stat) != "" && country.send(stat) != 0 && country.send(stat) != nil
              @demog_avg_n[stat] ||= 0
              @demog_avg_n[stat] += 1
              @demog_avg_total[stat] ||= 0.0
              @demog_avg_total[stat] += country.send(stat).to_f
            end
          end
          %w(perc_christian perc_evangelical pop_wfb_gdppp).each do |stat|
            if @demog_avg_n[stat].to_f > 0
              @demog[stat] = @demog_avg_total[stat].to_f / @demog_avg_n[stat].to_f
            else
              @demog[stat] = nil
            end
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

    def ensure_permission_by_person_id
      [283, 5173, 1301246379].include?(@person.id) 
    end

    def ensure_permission
      access_denied unless ensure_permission_by_person_id || 
        GlobalDashboardAccess.find_by_guid(ensure_permission_by_person_id, @person.try(:user).try(:guid))
        #ALLOWED_GUIDS.include?(@person.try(:user).try(:guid))
    end

    def all_mccs
      @all_mccs ||= GlobalProfile.all.collect(&:mission_critical_components).uniq.compact.sort
    end

    def all_mcc_options
      @all_mcc_options ||= all_mccs.collect{ |mcc|
        mcc == "" ? "No mcc chosen" : mcc
      }
    end

    def set_can_edit_stages
      @can_edit_stages = ensure_permission_by_person_id
    end
end
