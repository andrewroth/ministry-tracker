module StatsHelper
  unloadable

  def time_tab_link_to_remote(time)
    link_to_remote(time.capitalize, :url => {:action => "select_report"}, :with => "getWithStringForReportForm('#{time.downcase}')", :before => "beginLoadingStatsTab()", :complete => "completeLoadingStatsTab()")
  end

  def report_type_links_to_show
    report_types.collect {| key, value | key if authorized?(value[:action], value[:controller]) } - [:"#{@report_type}", nil]
  end

  def report_type_link_to_remote(report_type)
    text_label = report_types[report_type][:label]
    link_to_remote(text_label, :url => {:action => "select_report"}, :with => "getWithStringForReportForm(undefined, undefined, undefined, '#{report_type}')", :before => "reportTypeChange('#{text_label}')", :complete => "completeLoadingStatsTab()")
  end
  
  def get_links_for_report_types
    report_type_links_to_show.collect {| key | report_type_link_to_remote(key)}
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
      get_ministry.root.to_hash_with_only_the_children_person_is_involved_in(@me).to_json
    else
      get_ministry.root.to_hash_with_children.to_json
    end
  end

  def evaluate_stat_for_period(period_model, campus_ids, stat_hash)
    evaluation = 0
    if stat_hash[:column_type] == :database_column
      evaluation = period_model.evaluate_stat(campus_ids, stat_hash)
    elsif stat_hash[:column_type] == :sum
      stat_hash[:columns_sum].each { |cs| evaluation += evaluate_stat_for_period(period_model, campus_ids, stats_reports[cs[:report]][cs[:line]]) }
    end
    evaluation
  end

  def show_stat_hash_line(period_model_array, campus_ids, stat_hash)
    result = ""
    if stat_hash[:column_type] == :blank_line
      result = render(:partial => 'stats/blank_line')
    else
      result = render(:partial => 'stats/stats_line',
                      :locals => {
                          :special_css_class => stat_hash[:css_class].present? ? stat_hash[:css_class] : "",
                          :title => stat_hash[:label], 
                          :stats_array => period_model_array.collect { |pm| evaluate_stat_for_period(pm, campus_ids, stat_hash) } 
                      })
    end
    result
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
