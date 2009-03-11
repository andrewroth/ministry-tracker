# Be sure to restart your server when you modify this file.

ActiveSupport::Inflector.inflections do |inflect|
   inflect.plural /(campus|address)$/i, '\1es'
   inflect.singular /(campus|address)es$/i, '\1'
   inflect.uncountable %w( staff customize interested )
end
