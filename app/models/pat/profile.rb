class Pat::Profile < ActiveRecord::Base
  load_mappings

  set_inheritance_column "asdf"
  belongs_to :project, :class_name => "Pat::Project"
end
