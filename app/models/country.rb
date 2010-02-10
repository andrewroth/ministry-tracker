class Country < ActiveRecord::Base
  load_mappings
  include Common::Country
end
