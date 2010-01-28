class AccountadminAccountgroup < ActiveRecord::Base
  load_mappings

  has_many :users

  validates_presence_of _(:key)
  validates_uniqueness_of _(:key)
  validates_length_of _(:key), :maximum => 50
  validates_length_of _(:label_long), :maximum => 50
  validates_format_of _(:key), :with => /\[*\]/, :message => "must be surrounded by brackets, for example: [key7]"
end
