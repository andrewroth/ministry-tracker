class Permission < ActiveRecord::Base
  load_mappings
  validates_presence_of :description, :controller, :action
end
