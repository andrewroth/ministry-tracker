class AccountadminAccountadminaccess < ActiveRecord::Base
  load_mappings

  belongs_to :users, :foreign_key => :viewer_id

  validates_presence_of _(:viewer_id), _(:privilege)
  validates_length_of _(:privilege), :maximum => 1
end
