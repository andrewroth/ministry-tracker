Factory.define :accessgroup_1, :class => AccountadminAccessgroup, :singleton => true do |a|
  a.accessgroup_id '1'
  a.accesscategory_id '1'
  a.accessgroup_key '[accessgroup_key1]'
  a.english_value 'All'
end
