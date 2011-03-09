Factory.define :profile_1, :class => Pat::Profile do |p|
  p.id '1'
  p.project_id '1'
  p.viewer_id '7'
  p.type 'Applying'
  p.appln_id '1'
end

Factory.define :profile_2, :class => Pat::Profile do |p|
  p.id '2'
  p.project_id '1'
  p.viewer_id '7'
  p.type 'Acceptance'
  p.appln_id '1'
end
