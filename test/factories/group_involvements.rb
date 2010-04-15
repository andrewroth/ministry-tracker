Factory.define :groupinvolvement_1, :class => GroupInvolvement, :singleton => true do |g|
  g.id '1'
  g.person_id '50000'
  g.group_id '1'
  g.level 'leader'
end

Factory.define :groupinvolvement_2, :class => GroupInvolvement, :singleton => true do |g|
  g.id '2'
  g.person_id '1'
  g.level 'interested'
  g.group_id '2'
end

Factory.define :groupinvolvement_3, :class => GroupInvolvement, :singleton => true do |g|
  g.id '3'
  g.person_id '50000'
  g.group_id '3'
  g.level 'leader'
end

Factory.define :groupinvolvement_4, :class => GroupInvolvement, :singleton => true do |g|
  g.id '4'
  g.person_id '2'
  g.group_id '3'
  g.level 'leader'
end

Factory.define :groupinvolvement_5, :class => GroupInvolvement, :singleton => true do |g|
  g.id '5'
  g.person_id '50'
  g.group_id '3'
  g.level 'member'
end

Factory.define :groupinvolvement_6, :class => GroupInvolvement, :singleton => true do |g|
  g.id '6'
  g.person_id '2000'
  g.group_id '3'
  g.level 'leader'
end

Factory.define :groupinvolvement_7, :class => GroupInvolvement do |g|
  g.id '7'
  g.person_id '50000'
  g.group_id '2'
  g.level 'member'
  g.requested '1'
end
