require "csv"

class GlobalDashboardController < ApplicationController
  in_place_edit_for :global_country, :total_students
  in_place_edit_for :global_country, :total_schools
  in_place_edit_for :global_country, :total_spcs
  in_place_edit_for :global_country, :names_priority_spcs
  in_place_edit_for :global_country, :total_spcs_presence
  in_place_edit_for :global_country, :total_spcs_movement

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
  
  MONTH_LONG = %w[January February March April May June July August September October November December]
  MONTH_SHORT = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec]
  MCC_OPTIONS = [ "Any Mcc", "virtually-led", "church-led", "student-led", "leader-led" ]
  STAGE_OPTIONS = [ [ "Any Stage", "all" ], [ "Stage 1", 1], [ "Stage 2", 2], [ "Stage 3", 3] ]

  before_filter :ensure_permission
  before_filter :set_can_edit_stages
  before_filter :set_can_edit_slm
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
      "new_grth_mbr" => 'Growth Group Members',
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
      setup_stats([ GlobalCountry.first ], mcc_filters) # to get the instance var hashes set
      csv << columns.collect{ |c| country_column_names_to_strings[c] } #+ 

      metrics = [ "live_exp", "live_dec", "new_grth_mbr", "mvmt_mbr", "mvmt_ldr", "new_staff", "lifetime_lab" ]
      for c in countries
        row = []
        columns.each do |col|
          if metrics.include?(col)
            if col == "live_exp"
              setup_mm_stats([c.iso3], mcc_filters)
              row += metrics.collect{ |m| @whq[m] }
            end
          else
            row << c.send(col).to_s
          end
        end
        csv << row
      end
    end

    send_data(csv_out,
              :type => 'text/csv; charset=utf-8; header=present',
              :filename => "export.csv")

  end
  
  def export_submission_countries
    csv_out = ""
    CSV::Writer.generate(csv_out) do |csv|
    
      header_row = ["Country", "Overall Percent", "Months Reported"]
      MONTH_LONG.each { |m| header_row << m }
      csv << header_row

      GlobalArea.all.each do |area|
        area.global_countries.each do |country|
          
          month_data = {}
          MONTH_LONG.each_with_index do |ml, i|
            m = Month.find_by_month_desc "#{ml} #{params[:y]}"
            stat = country.global_dashboard_whq_stats.find_by_month_id m.id
            month_data[country] ||= {}
            month_data[country][MONTH_SHORT[i]] = stat.present?
          end
          
          months_with_data = 0
          MONTH_SHORT.each { |m| months_with_data += 1 if month_data[country][m] }
          
          row = [country.name, "#{((months_with_data.to_f / 12.00)*100).to_i}%", months_with_data]
          MONTH_SHORT.each { |m| row << month_data[country][m] ? "true" : "false" }
          csv << row
        end
      end
    end

    send_data(csv_out,
              :type => 'text/csv; charset=utf-8; header=present',
              :filename => "submission_report_countries_#{params[:y]}.csv")
  end
  
  def export_submission_areas
    csv_out = ""
    CSV::Writer.generate(csv_out) do |csv|
    
      header_row = ["Area", "Overall Percent"]
      MONTH_LONG.each { |m| header_row << m }
      csv << header_row

      GlobalArea.all.each do |area|
        num_countries_in_area = 0
        area_months_data_total = 0
        area_total_month_data_possible = 0
        area_month_data = {}
        MONTH_SHORT.each { |m| area_month_data[m] = 0 }
        
        if params[:s].to_s == STAGE_OPTIONS.first[1].to_s
          countries = GlobalCountry.all(:conditions => ["global_area_id = ?", area.id], :order => :name)
        else
          countries = GlobalCountry.all(:conditions => ["global_area_id = ? and stage = ?", area.id, params[:s]], :order => :name)
        end
        
        countries.each do |country|
          num_countries_in_area += 1
          
          month_data = {}
          MONTH_LONG.each_with_index do |ml, i|
            m = Month.find_by_month_desc "#{ml} #{params[:y]}"
            month_data[country] ||= {}
            month_data[country][MONTH_SHORT[i]] ||= 0
            
            if params[:mcc] == MCC_OPTIONS.first
              stat = country.global_dashboard_whq_stats.all(:conditions => {:month_id => m.id})
              month_data[country][MONTH_SHORT[i]] += stat.try(:size)
            else
              stat = country.global_dashboard_whq_stats.find_by_mcc_and_month_id(params[:mcc], m.id)
              month_data[country][MONTH_SHORT[i]] += stat.present? ? 1 : 0
            end
          end
          
          months_data_total = 0
          MONTH_SHORT.each do |m|
            area_month_data[m] ||= 0
            if month_data[country][m]
              months_data_total += month_data[country][m]
              area_month_data[m] += month_data[country][m]
            end
          end
          area_months_data_total += months_data_total
          area_total_month_data_possible += params[:mcc] == MCC_OPTIONS.first ? (MCC_OPTIONS.size-1)*12 : 12
        end
        area_total_month_data_possible_per_month = num_countries_in_area == 0 ? 0 : area_total_month_data_possible/num_countries_in_area
        row = [area.area, "#{area_total_month_data_possible == 0 ? 0 : ((area_months_data_total.to_f / area_total_month_data_possible.to_f)*100).to_i}%"]
        MONTH_SHORT.each { |m| row << "#{area_total_month_data_possible_per_month == 0 ? 0 : ((area_month_data[m].to_f / area_total_month_data_possible_per_month.to_f)*100).to_i}%" }
        csv << row
      end
    end

    send_data(csv_out,
              :type => 'text/csv; charset=utf-8; header=present',
              :filename => "submission_areas_report_mcc-#{params[:mcc] == MCC_OPTIONS.first ? 'any' : params[:mcc]}_stage-#{params[:s].to_s == STAGE_OPTIONS.first[1].to_s ? 'any' : params[:s]}_#{params[:y]}.csv")
  end

  def update_stats
    location_filter_arr, mcc_filters = setup_filters
    @no_filter = location_filter_arr.nil?
    setup
    setup_stats(location_filter_arr, mcc_filters) unless @no_filter
  end

  def update_ministry_metrics
    location_filter_arr, mcc_filters = setup_filters
    filters_isos = location_filter_arr.collect { |f| f.isos }.flatten.compact
    @no_filter = location_filter_arr.nil?
    setup
    setup_mm_stats(filters_isos, mcc_filters)
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

  def submission_area_report
    @mcc_options = MCC_OPTIONS
    @area_options = [["All Areas", 0]] + GlobalArea.all.collect{ |ga| [ ga.area, ga.id ] }
    @stage_options = STAGE_OPTIONS
    @month_options = [["All Months", 0]] + MONTH_LONG.each_with_index.collect { |m, i| [m, i+1] }
    @year_options = Year.all.collect(&:year_number)
    
    params[:mcc] ||= @mcc_options.first
    params[:a] ||= GlobalArea.find_by_area("South East Asia").id
    params[:s] ||= @stage_options.first[1]
    params[:m] ||= 0
    params[:y] ||= Year.current.year_number

    @month_short = MONTH_SHORT
    @month_long = MONTH_LONG
    
    @areas = params[:a].to_i == @area_options.first[1].to_i ? GlobalArea.all : GlobalArea.all(:conditions => {:id => params[:a]})

    if params[:m].to_i == 0
      @months = Month.all(:conditions => ["#{Month._(:calendar_year)} = ?", params[:y]], :order => "#{Month._(:number)}")
    else
      @months = Month.all(:conditions => ["#{Month._(:number)} = ? and #{Month._(:calendar_year)} = ?", params[:m], params[:y]], :order => "#{Month._(:number)}")
    end
    
    if params[:s].to_s == @stage_options.first[1].to_s
      @countries = GlobalCountry.all(:conditions => ["global_area_id in (?)", @areas.collect(&:id)], :order => :name)
    else
      @countries = GlobalCountry.all(:conditions => ["global_area_id in (?) and stage = ?", @areas.collect(&:id), params[:s]], :order => :name)
    end
    
    num_months_selected = @months.size
    num_mccs_selected = params[:mcc] == @mcc_options.first ? @mcc_options.size - 1 : 1
    @total_possible_reports_per_country = num_months_selected * num_mccs_selected
    @total_possible_reports_per_country_per_month = num_mccs_selected
    @total_possible_reports = @total_possible_reports_per_country * @countries.try(:size).to_i
    
    @total_reports = 0
    @reports = {}
    
    
    @countries.each do |country|
      @reports[country] ||= {}
      
      if params[:mcc] == @mcc_options.first
        @months.each do |month|
          @reports[country][month] ||= 0
          @reports[country][month] += country.global_dashboard_whq_stats.all(:conditions => ["month_id = ?", month.id]).try(:size).to_i
        end
      else
        @months.each do |month|
          @reports[country][month] ||= 0
          @reports[country][month] += country.global_dashboard_whq_stats.all(:conditions => ["mcc = ? and month_id = ?", params[:mcc], month.id]).try(:size).to_i
        end
      end
      
      @reports[country].each {|hash| @total_reports += hash[1]}
    end
  end

  protected

    def setup
      if !params[:include_zeros].present? && session[:include_zeros].present?
        params[:include_zeros] = session[:include_zeros]
      elsif params[:include_zeros].present?
        session[:include_zeros] = params[:include_zeros]
      end
      if !params[:l].present? && session[:l].present?
        params[:l] = session[:l]
      elsif params[:l].present?
        session[:l] = params[:l]
      end

      @grouped_options = [ [ "All", [ [ "All", "all" ] ] ] ]
      @grouped_options << [ "Areas", GlobalArea.all(:order => "area").collect{ |ga| [ ga.area, "a_#{ga.id}" ] } ]
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

    def setup_mm_stats(filters_isos, mcc_filters)
      @whq = ActiveSupport::OrderedHash.new
      #months = Month.find(:all, :conditions => [ "month_desc like ?", "% 2010%" ])
      #month_ids = months.collect(&:id)
      @year = nil
      @month_ids = nil
      if !@year.present? && !@month_ids.present? && mmt = params[:ministry_metric_timeframe]
        if mmt =~ /y_(.*)/
          @year = Year.find $1
          @month_ids = @year.months_by_literal_year.collect(&:id)
        elsif mmt =~ /m_(.*)/
          @month_ids = [ $1 ]
        elsif mmt == 'All'
          @month_ids = Month.all.collect(&:id)
        end
        @ministry_metric_timeframe = params[:ministry_metric_timeframe] || session[:ministry_metric_timeframe]
        session[:ministry_metric_timeframe] = @ministry_metric_timeframe
      else
        @ministry_metric_timeframe = "y_#{Year.current.id}"
        @year = Year.find_by_year_desc("2010 - 2011") || Year.find_by_year_desc("2010-2011")
        @month_ids = @year.months_by_literal_year.collect(&:id)
      end

      GlobalCountry.all.each do |country|
        if filters_isos.include?(country.iso3)
          %w(new_grth_mbr mvmt_mbr mvmt_ldr).each do |stat|
            whq_stats = country.global_dashboard_whq_stats.find_all_by_mcc_and_month_id(mcc_filters, @month_ids, 
              :joins => { :month => :year },
              :order => "year_desc ASC, month_number ASC",
              :select => "mcc, avg(#{stat}) as #{stat}_avg",
              :conditions => ("#{stat} != 0" unless params[:include_zeros] == "true"),
              :group => "mcc"
            )

            stat_val = whq_stats.inject(0) do |i,s| s.send("#{stat}_avg").to_f + i end 

            if stat_val
              @whq[stat] ||= 0
              @whq[stat] += stat_val
            end
            if stat == 'mvmt_ldr' && stat_val != 0
              whq_stats.each do |s|
                #logger.info "*** #{country.iso3} #{s.mcc}: #{s.send("#{stat}_avg")}"
              end
            end
          end

          gd_stat = country.global_dashboard_whq_stats.find_all_by_mcc_and_month_id(mcc_filters, @month_ids, 
            :joins => { :month => :year },
            :order => "year_desc ASC, month_number ASC",
            :select => "sum(live_exp) as live_exp_sum, sum(new_staff) as new_staff_sum, " + 
                       "sum(live_dec) as live_dec_sum, sum(lifetime_lab) as lifetime_lab_sum"
          ).last
          if gd_stat
            %w(live_exp live_dec new_staff lifetime_lab).each do |stat|
              if gd_stat["#{stat}_sum"]
                @whq[stat] ||= 0
                @whq[stat] += gd_stat["#{stat}_sum"].to_i
              end
            end
          end
        end

        %w(new_grth_mbr mvmt_mbr mvmt_ldr).each do |stat|
          @whq[stat] = @whq[stat].round if @whq[stat]
        end
      end

    end

    def setup_stats(area_filters, mcc_filters)
      filters_isos = area_filters.collect { |f|
        f.isos
      }.flatten.compact

      if area_filters.length == 1 && area_filters.first.is_a?(GlobalCountry)
        @global_country = @country = country = area_filters.first
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

      setup_mm_stats(filters_isos, mcc_filters)

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
      access_denied(true) unless ensure_permission_by_person_id || 
        GlobalDashboardAccess.find_by_guid(@person.try(:user).try(:guid))
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

    def set_can_edit_slm
      @can_edit_slm = is_ministry_admin || @me.is_global_dashboard_admin
    end

    def setup_filters
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

      return [ location_filter_arr, mcc_filters ]
    end
end
