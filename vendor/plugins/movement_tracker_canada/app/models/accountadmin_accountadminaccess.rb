class AccountadminAccountadminaccess < ActiveRecord::Base
  load_mappings

  belongs_to :user, :foreign_key => :viewer_id

  validates_presence_of :viewer_id, _(:privilege)
  validates_format_of _(:privilege), :with => /[1-2]{1}/
  validate :ensure_user_exists

  # pivilege was hardcoded in legacy, keep it around for legacy support
  PRIV = {:group => {:id => 1, :human => 'group'},
          :site  => {:id => 2, :human => 'site'},
          :unknown  => {:id => nil, :human => 'unknown'}}

  def ensure_user_exists
    errors.add('Viewer ID') unless User.find(:first, :conditions => ["#{_(:id, :user)} = ?", self.viewer_id])
  end

  def human_privilege
    case self.privilege
    when PRIV[:group][:id]
      return PRIV[:group][:human]
    when PRIV[:site][:id]
      return PRIV[:site][:human]
    else
      return PRIV[:unknown][:human]
    end
  end
  
end
