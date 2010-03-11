class User < ActiveRecord::Base
  include Authentication
  
  load_mappings
  include Common::Core::User
end
