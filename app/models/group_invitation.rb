class GroupInvitation < ActiveRecord::Base
  load_mappings
  
  belongs_to :group
  belongs_to :sender_person, :class_name => "Person"
  belongs_to :login_code
  
  after_initialize :init
  after_create :init

  validates_presence_of :group_id
  validates_presence_of :recipient_email
  validates_presence_of :sender_person_id
  
  def send_invite_email(base_url)
    UserMailer.deliver_group_invitation(self, base_url)
  end

  
  private
  
  def init
    unless self.login_code_id.present?
      lc = ::LoginCode.new
      lc.save!
      self.login_code_id = lc.id
      self.save!
    end
  end
  
end
