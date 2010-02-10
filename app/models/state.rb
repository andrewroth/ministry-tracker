class State < ActiveRecord::Base
  load_mappings
  include Common::State
end
