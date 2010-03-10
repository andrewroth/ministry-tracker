Factory.define :ministry_1, :class => Ministry, :singleton => true do |m|
  m.id '1'
  m.name 'YFC'
  m.address '108 E. Burlington Ave'
  m.city 'Westmont'
  m.state 'IL'
  m.zip '60559'
  m.country 'United States'
  m.phone '555'
  m.email 'asdf'
end

Factory.define :ministry_2, :class => Ministry, :singleton => true do |m|
  m.id '2'
  m.name 'Chicago Metro'
  m.address '108 E. Burlington Ave'
  m.city 'Westmont'
  m.state 'IL'
  m.zip '60559'
  m.country 'United States'
  m.phone '555'
  m.email 'asdf'
  m.parent_id '1'
  m.ministries_count '1'
end

Factory.define :ministry_3, :class => Ministry, :singleton => true do |m|
  m.id '3'
  m.name 'DG'
  m.address '108 E. Burlington Ave'
  m.city 'Westmont'
  m.state 'IL'
  m.zip '60559'
  m.country 'United States'
  m.phone '555'
  m.email 'asdf'
  m.parent_id '2'
end

Factory.define :ministry_4, :class => Ministry, :singleton => true do |m|
  m.id '4'
  m.name 'top'
  m.address 'asdf'
  m.city 'asdf'
  m.state 'IL'
  m.zip 'asdf'
  m.country 'USA'
  m.phone '124098'
  m.email 'asdf'
end

Factory.define :ministry_5, :class => Ministry, :singleton => true do |m|
  m.id '7'
  m.name 'under_top'
  m.address 'asdf'
  m.city 'asdf'
  m.state 'IL'
  m.zip 'asdf'
  m.country 'USA'
  m.phone '124098'
  m.email 'asdf'
  m.parent_id '4'
end

Factory.define :ministry_6, :class => Ministry, :singleton => true do |m|
  m.id '5'
  m.name  Cmt::CONFIG[:default_ministry_name] || 'No Ministry' 
end

Factory.define :ministry_7, :class => Ministry, :singleton => true do |m|
  m.id '6'
  m.name 'Check My Roles'
  m.address 'asdf'
  m.city 'asdf'
  m.state 'IL'
  m.zip 'asdf'
  m.country 'USA'
  m.phone '124098'
  m.email 'asdf'
  m.parent_id '1'
end
