require 'md5'

class UserCode < ActiveRecord::Base
  load_mappings
  include Common::Core::UserCode

  def self.new_code
    MD5.hexdigest((object_id + Time.now.to_i).to_s)
  end
end
