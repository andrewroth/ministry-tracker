I18n.default_locale = "en-CA"
I18n.load_path.sort! do |a,b| 
  if a.is_a?(Array) then 0
  elsif b.is_a?(Array) then 0
  elsif a =~ /en-CA.rb/ then 1
  elsif b =~ /en-CA.rb/ then -1
  else a <=> b
  end
end
