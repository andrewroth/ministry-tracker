class AccountadminLanguage < ActiveRecord::Base
  load_mappings

  has_many :users, :foreign_key => :language_id

  validates_presence_of _(:key), _(:code)
  validates_uniqueness_of _(:key), _(:code)
  validates_length_of _(:key), :maximum => 25
  validates_length_of _(:code), :maximum => 2
  validates_format_of _(:key), :with => /\[*\]/, :message => "must be surrounded by brackets, for example: [key7]"
  validates_no_association_data :users
end
