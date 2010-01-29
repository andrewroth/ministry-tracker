class AccountadminLanguage < ActiveRecord::Base
  load_mappings

  has_many :users

  validates_presence_of _(:key), _(:code)
  validates_uniqueness_of _(:key), _(:code)
  validates_length_of _(:key), :maximum => 25
  validates_length_of _(:code), :maximum => 2
  validates_format_of _(:key), :with => /\[*\]/, :message => "must be surrounded by brackets, for example: [key7]"
end
