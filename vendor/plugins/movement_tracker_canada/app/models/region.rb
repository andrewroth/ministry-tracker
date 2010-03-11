class Region < ActiveRecord::Base
  unloadable
  load_mappings

  include Legacy::Hrdb::Region
end
