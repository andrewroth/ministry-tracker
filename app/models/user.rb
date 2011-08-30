class User < ActiveRecord::Base
  include Authentication
  
  load_mappings
  include Common::Core::User
  include Common::Core::Ca::User

  has_many :user_codes
  has_many :api_keys
  has_one :global_dashboard_access, :foreign_key => "guid", :primary_key => "guid"

  has_many :profiles, :class_name => "Pat::Profile", :foreign_key => _(:viewer_id, :viewer)
end
