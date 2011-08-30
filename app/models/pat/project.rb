class Pat::Project < ActiveRecord::Base
  load_mappings
  belongs_to :event_group
end
