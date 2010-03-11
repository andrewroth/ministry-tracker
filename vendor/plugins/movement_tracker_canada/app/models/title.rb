class Title < ActiveRecord::Base
  unloadable
  load_mappings
  include Legacy::Hrdb::Title
end
