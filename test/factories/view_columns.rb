Factory.define :viewcolumn_1, :class => ViewColumn, :singleton => true do |v|
  v.id '1'
  v.view_id '1'
  v.column_id '1'
  v.position '1'
end

Factory.define :viewcolumn_2, :class => ViewColumn, :singleton => true do |v|
  v.id '2'
  v.view_id '1'
  v.column_id '2'
  v.position '2'
end

Factory.define :viewcolumn_3, :class => ViewColumn, :singleton => true do |v|
  v.id '3'
  v.view_id '1'
  v.column_id '3'
  v.position '3'
end
