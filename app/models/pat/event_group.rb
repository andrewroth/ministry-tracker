class Pat::EventGroup < ActiveRecord::Base
  set_inheritance_column "something_you_will_not_use"
  include Common::Pat::EventGroup
  load_mappings
end
