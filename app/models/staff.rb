class Staff < ActiveRecord::Base
  load_mappings
  include Common::Core::Staff
  include Legacy::Hrdb::CimHrdbStaff
end
