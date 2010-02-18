Factory.define :dorm_1, :class => Dorm do |d|
  d.id '1'
  d.campus_id '1'
  d.name '\'Mine\''
end

Factory.define :dorm_2, :class => Dorm do |d|
  d.id '2'
  d.campus_id '2'
  d.name '\'Yours\''
end
