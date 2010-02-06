class AccountadminAccessgroup < ActiveRecord::Base
  unloadable
  load_mappings

  has_many :users, :through => :accountadmin_vieweraccessgroups, :class_name => 'User'
  has_many :accountadmin_vieweraccessgroups, :foreign_key => :accessgroup_id, :class_name => 'AccountadminVieweraccessgroup'
  belongs_to :accountadmin_accesscategory, :foreign_key => :accesscategory_id

  validates_presence_of _(:key), _(:accesscategory_id)
  validates_uniqueness_of _(:key)
  validates_length_of _(:key), :maximum => 50
  validates_format_of _(:key), :with => /\[*\]/, :message => "must be surrounded by brackets, for example: [key7]"
  validates_no_association_data :accountadmin_vieweraccessgroups, :users

  def get_users(page, per_page)
    User.paginate(:page => page,
                  :per_page => per_page,
                  :joins => :accountadmin_vieweraccessgroups,
                  :conditions => ["#{AccountadminVieweraccessgroup.table_name}.#{:accessgroup_id} = ?", self.id])
  end

end
