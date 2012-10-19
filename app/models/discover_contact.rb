class DiscoverContact < Contact
  has_and_belongs_to_many :people, :join_table => 'contacts_people', :foreign_key => 'contact_id'

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :campus_id
end