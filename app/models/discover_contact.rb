class DiscoverContact < Contact
  has_and_belongs_to_many :people, :join_table => 'contacts_people', :foreign_key => 'contact_id'
end