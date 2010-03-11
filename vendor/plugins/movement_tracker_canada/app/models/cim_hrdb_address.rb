#class CimHrdbAddress < Address
class CimHrdbAddress < ActiveRecord::Base
  self.abstract_class = true
  unloadable
  load_mappings
  include Legacy::Hrdb::CimHrdbAddress
end
