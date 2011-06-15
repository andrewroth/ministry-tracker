
class UserCode < ActiveRecord::Base
  load_mappings
  include Common::Core::UserCode
end
