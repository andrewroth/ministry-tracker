module StatsHelper
  def time_tab_link_to_remote(time)
    link_to_remote(time.capitalize, :url => {:action => "select_report"}, :with => "getWithStringForReportForm('#{time.downcase}')", :before => "beginLoadingStatsTab()", :complete => "completeLoadingStatsTab()")
  end

  def get_hash_for_stats_ministry_selection_tree
    unless is_ministry_admin
      get_ministry.root.to_hash_with_only_children_person_involved_in(@me).to_json
    else
      get_ministry.root.to_hash_with_children.to_json
    end
  end
end
