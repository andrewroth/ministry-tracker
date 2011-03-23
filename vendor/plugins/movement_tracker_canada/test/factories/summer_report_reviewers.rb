Factory.define :summer_report_1_reviewer_1, :class => SummerReportReviewer do |r|
  r.id '1'
  r.summer_report_id '1'
  r.person_id '3000'
  r.reviewed nil
  r.approved nil
  r.review_notes nil
end

Factory.define :summer_report_1_reviewer_2, :class => SummerReportReviewer do |r|
  r.id '2'
  r.summer_report_id '1'
  r.person_id '2000'
  r.reviewed '1'
  r.approved '1'
  r.review_notes 'I approved it'
end
