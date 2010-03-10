Factory.define :ministrycampus_1, :class => MinistryCampus, :singleton => true do |m|
  m.id '1'
  m.ministry_id '1'
  m.campus_id '1'
end

Factory.define :ministrycampus_2, :class => MinistryCampus, :singleton => true do |m|
  m.id '2'
  m.ministry_id '2'
  m.campus_id '2'
end

Factory.define :ministrycampus_3, :class => MinistryCampus, :singleton => true do |m|
  m.id '3'
  m.ministry_id '1'
  m.campus_id '3'
end
