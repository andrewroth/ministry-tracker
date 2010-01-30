class AccountadminAccessgroup < ActiveRecord::Base
  load_mappings

  has_many :users, :through => :accountadmin_vieweraccessgroup, :class_name => 'User'
  has_many :accountadmin_vieweraccessgroups, :foreign_key => :accessgroup_id, :class_name => 'AccountadminVieweraccessgroup'
  belongs_to :accountadmin_accesscategory, :foreign_key => :accesscategory_id

  validates_presence_of _(:key), _(:accesscategory_id)
  validates_uniqueness_of _(:key)
  validates_length_of _(:key), :maximum => 50
  validates_format_of _(:key), :with => /\[*\]/, :message => "must be surrounded by brackets, for example: [key7]"
end
