Factory.define :ministryinvolvement_1, :class => MinistryInvolvement, :singleton => true do |m|
  m.id '1'
  m.person_id '50000'
  m.ministry_id '1'
  m.ministry_role_id '1'
  m.admin 'true'
end

Factory.define :ministryinvolvement_2, :class => MinistryInvolvement, :singleton => true do |m|
  m.id '2'
  m.person_id '50000'
  m.ministry_id '2'
  m.ministry_role_id '1'
  m.admin 'true'
end

Factory.define :ministryinvolvement_3, :class => MinistryInvolvement, :singleton => true do |m|
  m.id '3'
  m.person_id '3000'
  m.ministry_id '2'
  m.ministry_role_id '5'
end

Factory.define :ministryinvolvement_4, :class => MinistryInvolvement, :singleton => true do |m|
  m.id '4'
  m.person_id '2000'
  m.ministry_id '1'
  m.ministry_role_id '4' # sue student ministry leader
end

Factory.define :ministryinvolvement_5, :class => MinistryInvolvement, :singleton => true do |m|
  m.id '5'
  m.person_id '4001'
  m.ministry_id '7'
  m.ministry_role_id '4' # ministry leader
end

Factory.define :ministryinvolvement_6, :class => MinistryInvolvement, :singleton => true do |m|
  m.id '6'
  m.person_id '4002'
  m.ministry_id '4'
  m.ministry_role_id '10'
end
