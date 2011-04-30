Factory.define :summer_report_1, :class => SummerReport do |r|
  r.id '1'
  r.person_id '50000'
  r.year_id '1'
  r.joined_staff '1999'
  r.days_of_holiday '2'
  r.monthly_goal '2000'
  r.monthly_have '1999'
  r.monthly_needed '1'
  r.num_weeks_of_mpd '2'
  r.num_weeks_of_mpm '1'
  r.support_coach '0'
  r.accountability_partner 'Mr. Joe'
  r.notes 'I love summer time'

  r.summer_report_weeks_attributes [
    {:week_id => '10', :summer_report_assignment_id => '2', :description => 'this is a description of my week'},
    {:week_id => '11', :summer_report_assignment_id => '1', :description => ''}]

  r.summer_report_reviewers_attributes [
    {:person_id => '3000', :reviewed => nil, :approved => nil, :review_notes => nil},
    {:person_id => '2000', :reviewed => '1', :approved => '1', :review_notes => 'I approved it'}]

end
