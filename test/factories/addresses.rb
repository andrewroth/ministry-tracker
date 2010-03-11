Factory.define :address_1, :class => Address do |a|
  a.id '1'
  a.address_type 'current'
  a.person_id '50000'
  a.title 'Home'
  a.address1 '108 E. Burlington Ave.'
  a.city 'Westmont'
  a.state 'WY'
  a.zip '60559'
  a.phone '847-980-1420'
  a.start_date '12/15/2006'
  a.email 'josh.starcher@uscm.org'
end

Factory.define :address_2, :class => Address do |a|
  a.id '2'
  a.address_type 'emergency1'
  a.person_id '1'
  a.title 'Emergency'
end

Factory.define :address_3, :class => Address do |a|
  a.id '3'
  a.person_id '2000'
  a.address_type 'current'
  a.email 'bob@uscm.org'
end
