class Assignment < ActiveRecord::Base
  unloadable
  load_mappings

  include Legacy::Hrdb::Assignment
end
