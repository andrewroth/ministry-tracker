Factory.define :summer_report_1_week_1, :class => SummerReportWeek do |w|
  w.id '1'
  w.summer_report_id '1'
  w.week_id '10'
  w.summer_report_assignment_id '2'
  w.description 'this is a description of my week'
end

Factory.define :summer_report_1_week_2, :class => SummerReportWeek do |w|
  w.id '2'
  w.summer_report_id '1'
  w.week_id '11'
  w.summer_report_assignment_id '1'
  w.description ''
end
