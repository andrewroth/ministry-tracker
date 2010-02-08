class AccountadminAccesscategory < ActiveRecord::Base
  unloadable
  load_mappings

  has_many :accountadmin_accessgroups, :foreign_key => :accesscategory_id

  validates_presence_of _(:key)
  validates_uniqueness_of _(:key)
  validates_length_of _(:key), :maximum => 50
  validates_format_of _(:key), :with => /\[*\]/, :message => "must be surrounded by brackets, for example: [key7]"
  validates_no_association_data :accountadmin_accessgroups
end
