#I18n.default_locale = "en-CA"
#I18n.default_locale = "lolcat"
I18n.default_locale = "fr"
#I18n.default_locale = "test"
I18n.load_path.sort! do |a,b| 
  if a.is_a?(Array) then 0
  elsif b.is_a?(Array) then 0
  elsif a =~ /en-CA.rb/ then 1
  elsif b =~ /en-CA.rb/ then -1
  else a <=> b
  end
end

I18n.backend.class.send(:include, I18n::Backend::Fallbacks)
I18n.fallbacks.map('fr' => 'en-CA')

# force only our English version and French to be available
I18n.available_locales = [ :"en-CA", "fr" ]
