# Question: Is a county the same as a city?
class County < ActiveRecord::Base
  load_mappings
  include Common::Core::County
end
