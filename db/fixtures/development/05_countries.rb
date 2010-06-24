Country.seed(:country) do |c|
  c.country = "Canada"
  c.is_closed = false
  c.code = "CA"
  c.iso_code = "CA"
end

Country.seed(:country) do |c|
  c.country = "US"
  c.is_closed = false
  c.code = "US"
  c.iso_code = "US"
end
