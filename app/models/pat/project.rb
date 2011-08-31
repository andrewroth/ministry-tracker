class Pat::Project < ActiveRecord::Base
  load_mappings
  belongs_to :event_group, :class_name => "Pat::EventGroup"
end
