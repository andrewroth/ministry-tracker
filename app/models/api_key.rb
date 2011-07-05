class ApiKey < ActiveRecord::Base
  load_mappings
  
  belongs_to :user
  belongs_to :login_code
  
  after_initialize :init
  after_create :init
  
  validates_presence_of :user_id
  validates_presence_of :purpose
  validates_associated :user
  validate :user_exists
  validates_uniqueness_of :login_code_id, :allow_blank => true, :allow_nil => true
  
  
  
  private
  
  def init
    LoginCode.set_login_code_id(self)
  end
  
  def user_exists
    errors.add(:user_id, "doesn't exist") unless self.user_id && self.user.present?
  end
end
