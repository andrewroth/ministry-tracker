class CimHrdbPersonYear < ActiveRecord::Base
  unloadable
  load_mappings
  include Legacy::Hrdb::CimHrdbPersonYear
end
