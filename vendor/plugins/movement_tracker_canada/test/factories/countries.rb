Factory.define :country_1, :class => Country, :singleton => true do |c|
  c.id '1'
  c.country 'United States'
  c.code 'USA'
end
