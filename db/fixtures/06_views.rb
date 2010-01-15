Ministry.all.each do |m|
  View.seed(:title, :ministry_id) do |c|
    c.ministry_id = m.id
    c.title = 'Default'
    c.default_view = true
  end
end
