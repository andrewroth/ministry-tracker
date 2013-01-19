class DiscoverContact < Contact
  load_mappings

  has_and_belongs_to_many :people, :join_table => ContactsPerson.table_name, :foreign_key => ContactsPerson._(:contact_id)
end