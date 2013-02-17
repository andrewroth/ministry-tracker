class AddSomeIndexes < ActiveRecord::Migration
  def self.up
    add_index Contact.table_name, [ :type, :id ]
    add_index Contact.table_name, [ :first_name ]
    add_index Contact.table_name, [ :last_name ]
    add_index Contact.table_name, [ :email ]
    add_index Contact.table_name, [ :campus_id ]

    add_index ContactsPerson.table_name, [ :contact_id ]
    add_index ContactsPerson.table_name, [ :person_id, :contact_id ]

    add_index Person.table_name, [ :person_fname ]
    add_index Person.table_name, [ :person_lname ]

    add_index Note.table_name, [ :noteable_type, :noteable_id ]
    add_index Note.table_name, [ :person_id ]

    add_index Activity.table_name, [ :reportable_type, :reportable_id ]
    add_index Activity.table_name, [ :reporter_id ]

    add_index LabelPerson.table_name, [ :person_id ]

    add_index Group.table_name, [ :name ]
  end

  def self.down
  end
end
