Factory.define :global_area_1, :class => GlobalArea, :singleton => true do |s|
  s.id '1'
  s.area 'area_1'
end

Factory.define :global_area_2, :class => GlobalArea, :singleton => true do |s|
  s.id '2'
  s.area 'area_2'
end

