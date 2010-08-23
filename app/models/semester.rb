class Semester < ActiveRecord::Base
  load_mappings
  include Common::Core::Semester
end
