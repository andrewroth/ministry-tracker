class Permission < ActiveRecord::Base
  load_mappings

  has_many :ministry_role_permissions

  validates_presence_of :description, :controller, :action
end
