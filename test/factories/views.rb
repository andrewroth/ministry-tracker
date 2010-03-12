Factory.define :view_1, :class => View, :singleton => true do |v|
  v.id '1'
  v.title 'default'
  v.ministry_id '1'
end

Factory.define :view_2, :class => View, :singleton => true do |v|
  v.id '2'
  v.title 'secondary'
  v.ministry_id '1'
end
