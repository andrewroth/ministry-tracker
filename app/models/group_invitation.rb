class GroupInvitation < ActiveRecord::Base
  load_mappings
  
  belongs_to :group
  belongs_to :sender_person, :class_name => "Person"
  belongs_to :login_code
  
  after_initialize :init
  after_create :init
  
  
  private
  
  def init
    lc = ::LoginCode.new
    lc.save!
    self.login_code_id = lc.id
    self.save!
  end
end
