class AccountadminAccountadminaccess < ActiveRecord::Base
  load_mappings

  belongs_to :user, :foreign_key => :viewer_id
  belongs_to :cim_hrdb_priv, :foreign_key => _(:privilege_id)

  validates_presence_of :viewer_id, _(:privilege_id)
  validate :ensure_user_exists

  def ensure_user_exists
    errors.add('Viewer ID') unless User.find(:first, :conditions => ["#{_(:id, :user)} = ?", self.viewer_id])
  end

end
