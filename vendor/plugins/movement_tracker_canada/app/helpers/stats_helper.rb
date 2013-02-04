module StatsHelper
  unloadable

  def ministry_id_with_campus_id(campus)
    ministry_id = 0
    campus.ministries.each{|m| ministry_id = m.id if m.children.count == 0 }
    "#{ministry_id}_#{campus.id}"
  end

  def campus_link_to_remote(campus, report_type)
    report_type = 'c4c' if report_type.nil?
    ministry_id = ministry_id_with_campus_id(campus)
    link_to_remote(campus.campus_shortDesc, :url => {:action => "select_report"}, :with => "getWithStringForReportForm(null, '#{ministry_id}', 'summary', '#{report_type}')", :before => "beginLoadingStatsTab()", :complete => "completeLoadingStatsTab()")
  end

  def period_description_for_column_title(period)
    description = ""
    if period.class.name == "Week"
      description = "Week #{period.month.weeks.index(period) + 1}"
    else
      description = period.description
    end
    description
  end

  def time_tab_link_to_remote(time)
    link_to_remote(time.capitalize, :url => {:action => "select_report"}, :with => "getWithStringForReportForm('#{time.downcase}')", :before => "beginLoadingStatsTab()", :complete => "completeLoadingStatsTab()")
  end

  def report_type_links_to_show
    @report_type_links_to_show ||= report_types.collect {| key, value | key if (authorized?(value[:action], value[:controller]) && !(value[:hidden] == true)) }.compact.sort { |x, y| report_types[x][:order] <=> report_types[y][:order] }
  end

  def report_type_link_to_remote(report_type)
    text_label = report_types[report_type][:label]
    link_to_remote(text_label, :url => {:action => "select_report"}, :with => "getWithStringForReportForm(undefined, undefined, undefined, '#{report_type}')", :before => "reportTypeChange('#{text_label}')", :complete => "completeLoadingStatsTab()")
  end

  def get_links_for_report_types
    @get_links_for_report_types ||= report_type_links_to_show.collect {| key | report_type_link_to_remote(key)}
  end

  def order_by_link(text, column)
    link_to_remote(text, :url => {:action => "select_report"}, :with => "'order_by=#{column}'", :before => "beginLoadingStatsTab()", :complete => "completeLoadingStatsTab()", :html => { :title => "Sort by #{text}" })
  end

  def single_stat_link(stat_hash, single_stat_reference)
    link_to_remote(stat_hash[:label], :url => {:action => "select_report"}, :with => "'report_type=one_stat&statreport=#{single_stat_reference[0]}&stat=#{single_stat_reference[1]}'", :before => "beginLoadingStatsTab()", :complete => "completeLoadingStatsTab()")
  end

  def show_summary_report(report_type, permission_granted)
    render :partial => 'stats/show_specific_summary_report',
    :locals => {
        :report_symbol => report_type,
        :permission_granted => permission_granted
    }
  end

  def show_report_type_list_links
    render :partial => 'stats/report_type_list_links'
  end

  def get_hash_for_stats_ministry_selection_tree
    unless is_ministry_admin
      get_ministry.root.to_hash_with_only_the_children_person_is_involved_in(@me, authorized?("view_ministries_under", "stats")).to_json
    else
      get_ministry.root.to_hash_with_children(authorized?("view_ministries_under", "stats")).to_json
    end
  end

  def give_percentage(dividend, divisor)
    result = 0
    result = dividend.to_f / divisor.to_f unless divisor.nil? || divisor == 0 || dividend.nil?
    result = (result * 10000.0).round / 100.0
    "#{result}%"
  end

  def evaluate_stat_for_period(period_model, campus_ids, stat_hash, staff_id = nil)
    evaluation = 0

    if stat_hash[:column_type] == :database_column
      evaluation = period_model.evaluate_stat(campus_ids, stat_hash, staff_id)

    elsif stat_hash[:column_type] == :sum
      stat_hash[:columns_sum].each { |cs| evaluation += evaluate_stat_for_period(period_model, campus_ids, stats_reports[cs[:report]][cs[:line]], staff_id).to_i }

    elsif stat_hash[:column_type] == :division
      dividend_stat = stats_reports[stat_hash[:dividend][:report]][stat_hash[:dividend][:line]]
      divisor_stat = stats_reports[stat_hash[:divisor][:report]][stat_hash[:divisor][:line]]

      dividend = evaluate_stat_for_period(period_model, campus_ids, dividend_stat, staff_id)
      divisor = evaluate_stat_for_period(period_model, campus_ids, divisor_stat, staff_id)

      evaluation = give_percentage(dividend, divisor)

    elsif stat_hash[:column_type] == :count_model_with_condition
      if stat_hash[:model].constantize.column_names.include?('updated_at')
        merge_in_conditions = {
          :campus_id => campus_ids,
          :updated_at => (period_model.start_date.to_date)..(period_model.end_date.to_date + 1.day)
        }
        evaluation = stat_hash[:model].constantize.count :all, :conditions => (stat_hash[:conditions] || {}).merge(merge_in_conditions)
      else
        evaluation = nil
      end
    end

    evaluation
  end

  def no_weekly_data(period_model, campus_ids, staff_id = nil)
    period_model.no_weekly_data(campus_ids, staff_id)
  end

  def line_should_show(period_model_array, stat_hash)
    accepted_collections = []
    unless period_model_array.empty?
      pm = period_model_array[0]
      if pm.is_a?(Week)
        accepted_collections = [:weekly, :prc]
      elsif pm.is_a?(Month)
        accepted_collections = [:weekly, :prc, :monthly]
      elsif pm.is_a?(Semester)
        accepted_collections = [:weekly, :prc, :monthly, :semesterly]
      elsif pm.is_a?(Year)
        accepted_collections = [:weekly, :prc, :monthly, :semesterly, :yearly]
      end
    end
    accepted_collections.include?(stat_hash[:collected])
  end

  def evaluate_special_total(period_model_array, campus_ids, stat_hash, staff_id = nil)
    special_total = nil

    if stat_hash[:column_type] == :division
      dividend_stat = stats_reports[stat_hash[:dividend][:report]][stat_hash[:dividend][:line]]
      divisor_stat = stats_reports[stat_hash[:divisor][:report]][stat_hash[:divisor][:line]]

      dividend = 0
      divisor = 0
      period_model_array.each do |pm|
        dividend += evaluate_stat_for_period(pm, campus_ids, dividend_stat, staff_id)
        divisor += evaluate_stat_for_period(pm, campus_ids, divisor_stat, staff_id)
      end
      special_total = give_percentage(dividend, divisor)

    elsif stat_hash[:column_type] == :count_model_with_condition && !stat_hash[:model].constantize.column_names.include?('updated_at')
      merge_in_conditions = {
        :campus_id => campus_ids
      }
      special_total = stat_hash[:model].constantize.count :all, :conditions => (stat_hash[:conditions] || {}).merge(merge_in_conditions)
    end

    special_total
  end

  def show_stat_hash_line(period_model_array, campus_ids, stat_hash, staff_id = nil, alternate_title = nil, single_stat_reference = nil)
    result = ""

    title = stat_hash[:label]
    title = alternate_title unless alternate_title.nil?
    title = single_stat_link(stat_hash, single_stat_reference) unless single_stat_reference.nil?

    if stat_hash[:column_type] == :blank_line
      result = render 'stats/blank_line'

    elsif line_should_show(period_model_array, stat_hash)
      result = campus_ids.blank? ? '' : render('stats/stats_line',
        :special_css_class => stat_hash[:css_class].present? ? stat_hash[:css_class] : "",
        :title => title,
        :stats_array => period_model_array.collect { |pm| evaluate_stat_for_period(pm, campus_ids, stat_hash, staff_id) },
        :special_total => evaluate_special_total(period_model_array, campus_ids, stat_hash, staff_id),
        :print_total => print_stat_total?(stat_hash))
    end

    result
  end

  def print_stat_total?(stat_hash)
    (stat_hash[:show_total] == false || stat_hash[:grouping_method] == :last_non_zero) ? false : true
  end

  def stat_report(report)
    stats_reports[report].sort { |a,b| a[1][:order] <=> b[1][:order]}
  end

  def show_stat_for_semesters(title, stat, semesters, campus_ids)
    render :partial => 'stats/stats_line',
    :locals => {
        :special_css_class => "",
        :title => title,
        :stats_array => semesters.collect { |semester| semester.find_weekly_stats_campuses(campus_ids, stat) }
    }
  end

  def show_semester_highlight_stat(title, stat, semesters, campus_ids)
    render :partial => 'stats/stats_line',
    :locals => {
        :special_css_class => "",
        :title => title,
        :stats_array => semesters.collect { |semester|  semester.find_stats_semester_campuses(campus_ids, stat) }
    }
  end

  def show_summary_weekly_stat_by_month(title, stat, months, campus_ids)
    render :partial => 'stats/stats_line',
    :locals => {
        :special_css_class => "",
        :title => title,
        :stats_array => months.collect { |month| month.find_weekly_stats_campuses(campus_ids, stat) }
    }
  end

  def show_summary_monthly_stat_by_month(title, stat, months, campus_ids)
    render :partial => 'stats/stats_line',
    :locals => {
        :special_css_class => "",
        :title => title,
        :stats_array => months.collect { |month|  month.find_monthly_stats_campuses(campus_ids,stat) }
    }
  end

  def show_summary_monthly_stat_by_year(title, stat, semesters, campus_ids)
    render :partial => 'stats/stats_line',
    :locals => {
        :special_css_class => "",
        :title => title,
        :stats_array => semesters.collect { |semester|  semester.find_monthly_stats_campuses(campus_ids,stat) }
    }
  end

   def show_summary_by_week_stat(title, stat, weeks, ministry_id)
    render :partial => 'stats/stats_line',
    :locals => {
        :special_css_class => "",
        :title => title,
        :stats_array => weeks.collect { |wk|  Week.find_ministry_stats_week(wk.id, ministry_id,stat) }
    }
  end

end
