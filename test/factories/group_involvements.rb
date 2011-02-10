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

Factory.define :groupinvolvement_8, :class => GroupInvolvement do |g|
  g.id '8'
  g.person_id '50000'
  g.group_id '4'
  g.level 'interested'
end

Factory.define :groupinvolvement_9, :class => GroupInvolvement do |g|
  g.id '9'
  g.person_id '50000'
  g.group_id '5'
  g.level 'member'
end

Factory.define :groupinvolvement_10, :class => GroupInvolvement do |g|
  g.id '10'
  g.person_id '50000'
  g.group_id '6'
  g.level 'member'
  g.requested '1'
end

Factory.define :groupinvolvement_11, :class => GroupInvolvement, :singleton => true do |g|
  g.id '11'
  g.person_id '4001'
  g.group_id '4'
  g.level 'member'    
end

Factory.define :groupinvolvement_12, :class => GroupInvolvement, :singleton => true do |g|
  g.id '12'
  g.person_id '4001'
  g.group_id '5'
  g.level 'leader'   
end
