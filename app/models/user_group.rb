class UserGroup < ActiveRecord::Base
  load_mappings
  
  belongs_to :ministry
  has_many :user_group_permissions, :include => :permission
  has_many :permissions, :through => :user_group_permissions
  
  validates_presence_of :name, :message => "can't be blank"
end
