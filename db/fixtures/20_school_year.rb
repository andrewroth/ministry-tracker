for i in 1..5
  SchoolYear.seed(:name) do |sy|
    sy.name = 'Year ' + i.to_s
    sy.level = 'Level ' + i.to_s
    sy.position = i              
  end
end