Factory.define :conference_1, :class => Conference, :singleton => true do |c|
  c.column 'value'
end

Factory.define :conference_2, :class => Conference, :singleton => true do |c|
  c.column 'value'
end
