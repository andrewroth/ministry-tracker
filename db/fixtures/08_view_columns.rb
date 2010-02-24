#v_id = Ministry.find_by_name("Campus for Christ").views.first.id

for v_id in Ministry.all.collect{ |m| m.views.first }.compact.collect(&:id)
  # first name
  ViewColumn.seed(:view_id, :column_id) do |vc|
    vc.view_id = v_id
    vc.column_id = 1
  end

  # last name
  ViewColumn.seed(:view_id, :column_id) do |vc|
    vc.view_id = v_id
    vc.column_id = 2
  end

=begin
# street
ViewColumn.seed(:view_id, :column_id) do |vc|
  vc.view_id = v_id
  vc.column_id = 3
end
=end

  # city
  #ViewColumn.seed(:view_id, :column_id) do |vc|
  #  vc.view_id = v_id
  #  vc.column_id = 4
  #end

  # state
  #ViewColumn.seed(:view_id, :column_id) do |vc|
  #  vc.view_id = v_id
  #  vc.column_id = 5
  #end

=begin
# zip
ViewColumn.seed(:view_id, :column_id) do |vc|
  vc.view_id = v_id
  vc.column_id = 6
end
=end

  # email
  ViewColumn.seed(:view_id, :column_id) do |vc|
    vc.view_id = v_id
    vc.column_id = 7
  end

=begin
# picture
ViewColumn.seed(:view_id, :column_id) do |vc|
  vc.view_id = v_id
  vc.column_id = 8
end
=end

  # campus
  ViewColumn.seed(:view_id, :column_id) do |vc|
    vc.view_id = v_id
    vc.column_id = 9
  end

  # school year
  ViewColumn.seed(:view_id, :column_id) do |vc|
    vc.view_id = v_id
    vc.column_id = 10
  end

  # last login
  #ViewColumn.seed(:view_id, :column_id) do |vc|
  #  vc.view_id = v_id
  #  vc.column_id = 11
  #end

  # on pulse since
  #ViewColumn.seed(:view_id, :column_id) do |vc|
  #  vc.view_id = v_id
  #  vc.column_id = 12
  #end

  # timetable last updated
  ViewColumn.seed(:view_id, :column_id) do |vc|
    vc.view_id = v_id
    vc.column_id = 13
  end
end
