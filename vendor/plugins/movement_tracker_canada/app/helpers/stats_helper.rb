module StatsHelper
  def time_tab_link_to_remote(time)
    link_to_remote(time.capitalize, :url => {:action => "select_report"}, :with => "getWithStringForReportForm('#{time.downcase}')", :before => "beginLoadingStatsTab()", :complete => "completeLoadingStatsTab()")
  end
end
