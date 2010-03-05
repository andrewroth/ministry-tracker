class User < ActiveRecord::Base
  load_mappings
  include Common::Core::User
end
