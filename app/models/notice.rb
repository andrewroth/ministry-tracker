class Notice < ActiveRecord::Base
  has_many :dismissed_notice, :dependent => :destroy

  validates_presence_of :message
end
