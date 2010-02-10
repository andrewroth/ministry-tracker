class User < ActiveRecord::Base
  load_mappings
  include Common::User
end
