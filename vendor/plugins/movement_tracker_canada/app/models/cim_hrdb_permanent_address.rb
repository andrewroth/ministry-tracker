class CimHrdbPermanentAddress < CimHrdbAddress
  unloadable
  load_mappings
  include Legacy::Hrdb::CimHrdbPermanentAddress
end
