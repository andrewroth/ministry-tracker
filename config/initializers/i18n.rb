I18n.default_locale = "en-CA"

I18n.backend.class.send(:include, I18n::Backend::Fallbacks)
I18n.fallbacks[:testing] = []

# force only our English version and French to be available
I18n.available_locales = [ :"en-CA", "fr", "testing" ]
