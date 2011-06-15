Factory.define :global_country_1, :class => GlobalCountry, :singleton => true do |s|
  s.id '1'
  s.name 'country_1'
  s.global_area_id '1'
end

Factory.define :global_country_2, :class => GlobalCountry, :singleton => true do |s|
  s.id '2'
  s.name 'country_2'
  s.global_area_id '2'
end

