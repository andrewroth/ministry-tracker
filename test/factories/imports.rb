Factory.define :import_1, :class => Import, :singleton => true do |i|
  i.column 'value'
end

Factory.define :import_2, :class => Import, :singleton => true do |i|
  i.column 'value'
end
