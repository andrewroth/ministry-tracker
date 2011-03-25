module GlobalDashboardHelper
  COLUMNS_TO_LABELS = {
    "perc_christian" => "Percent Christian",
    "perc_evangelical" => "Percent Evangelical",
    "pop_2010" => "2010 Population",
    "pop_2015" => "2015 Expected Population",
    "pop_2020" => "2020 Expected Population",
    "pop_wfb_gdppp" => "GDP Per Person",

    "staff_count_2002" => "2002 Staff Count",
    "staff_count_2009" => "2009 Staff Count",

    "total_income_FY10" => "Total Income (FY'10)",
    "locally_funded_FY10" => "% Locally Funded (FY'10)",

    "Live exp" => "Live Exposures",
    "Live dec" => "Live Decisions",
    "New grth mbr" => "New Growth Group Members",
    "Mvmt mbr" => "Movement Members",
    "Mvmt ldr" => "Movement Leaders",
    "Lifetime lab" => "Lifetime labourers"
  }
 
  def column_humanize(c)
    COLUMNS_TO_LABELS[c] || c
  end
end
