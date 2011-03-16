Factory.define :project_1, :class => Pat::Project do |p|
  p.id '1'
  p.title 'project 1'
  p.event_group_id 75
end

Factory.define :project_2, :class => Pat::Project do |p|
  p.id '2'
  p.title 'project 2'
  p.event_group_id 75
end
