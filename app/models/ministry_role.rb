class MinistryRole < ActiveRecord::Base
  load_mappings
  include Common::Core::MinistryRole
  include Common::Core::Ca::MinistryRole
end
