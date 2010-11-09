class Notice < ActiveRecord::Base
  has_many :dismissed_notice, :dependent => :destroy
end
