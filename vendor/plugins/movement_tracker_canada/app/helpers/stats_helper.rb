module StatsHelper
  unloadable

  def time_tab_link_to_remote(time)
    link_to_remote(time.capitalize, :url => {:action => "select_report"}, :with => "getWithStringForReportForm('#{time.downcase}')", :before => "beginLoadingStatsTab()", :complete => "completeLoadingStatsTab()")
  end

  def get_hash_for_stats_ministry_selection_tree
    unless is_ministry_admin
      get_ministry.root.to_hash_with_only_the_children_person_is_involved_in(@me).to_json
    else
      get_ministry.root.to_hash_with_children.to_json
    end
  end

  def show_totals_for_stat_group(title, stat_array)
    render :partial => 'stats/stats_line_total',
    :locals => {
        :title => title, 
        :stats_array => stat_array
    }
  end
  
  def show_stat_for_semesters(title, stat, semesters, campus_ids)
    render :partial => 'stats/stats_line',
    :locals => {
        :title => title, 
        :stats_array => semesters.collect { |semester| semester.find_weekly_stats_campuses(campus_ids, stat) } 
    }
  end

  def show_semester_highlight_stat(title, stat, semesters, campus_ids)
    render :partial => 'stats/stats_line',
    :locals => {
        :title => title, 
        :stats_array => semesters.collect { |semester|  semester.find_stats_semester_campuses(campus_ids, stat) } 
    }
  end

  def show_summary_weekly_stat_by_month(title, stat, months, campus_ids)
    render :partial => 'stats/stats_line',
    :locals => {
        :title => title, 
        :stats_array => months.collect { |month| month.find_weekly_stats_campuses(campus_ids, stat) } 
    }
  end

  def show_summary_monthly_stat_by_month(title, stat, months, campus_ids)
    render :partial => 'stats/stats_line',
    :locals => {
        :title => title, 
        :stats_array => months.collect { |month|  month.find_monthly_stats_campuses(campus_ids,stat) } 
    }
  end

  def show_summary_monthly_stat_by_year(title, stat, semesters, campus_ids)
    render :partial => 'stats/stats_line',
    :locals => {
        :title => title, 
        :stats_array => semesters.collect { |semester|  semester.find_monthly_stats_campuses(campus_ids,stat) } 
    }
  end

   def show_summary_by_week_stat(title, stat, weeks, ministry_id)
    render :partial => 'stats/stats_line',
    :locals => {
        :title => title, 
        :stats_array => weeks.collect { |wk|  Week.find_ministry_stats_week(wk.id, ministry_id,stat) } 
    }
  end

 
end
