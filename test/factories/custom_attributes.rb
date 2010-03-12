Factory.define :customattribute_1, :class => CustomAttribute, :singleton => true do |c|
  c.id '1'
  c.name 'foo bar'
  c.ministry_id '1'
  c.type 'ProfileQuestion'
  c.value_type 'text_field'
end

Factory.define :customattribute_2, :class => CustomAttribute, :singleton => true do |c|
  c.id '2'
  c.name 'bar'
  c.ministry_id '1'
  c.type 'InvolvementQuestion'
  c.value_type 'check_box'
end

Factory.define :customattribute_3, :class => CustomAttribute, :singleton => true do |c|
  c.id '3'
  c.name 'bar'
  c.ministry_id '1'
  c.type 'InvolvementQuestion'
  c.value_type 'text_area'
end

Factory.define :customattribute_4, :class => CustomAttribute, :singleton => true do |c|
  c.id '4'
  c.name 'bar'
  c.ministry_id '1'
  c.type 'InvolvementQuestion'
  c.value_type 'date_select'
end
