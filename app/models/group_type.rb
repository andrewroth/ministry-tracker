
class GroupType < ActiveRecord::Base
  load_mappings
  belongs_to :ministry
  has_many :groups
  validates_presence_of :group_type, :ministry_id
end
