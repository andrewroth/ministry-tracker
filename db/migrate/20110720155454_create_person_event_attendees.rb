class CreatePersonEventAttendees < ActiveRecord::Migration
  def self.up
    begin
      create_table :person_event_attendees do |t|
        t.integer :person_id
        t.integer :event_attendee_id
        t.timestamps
      end
      add_index PersonEventAttendee.table_name, :person_id
      add_index PersonEventAttendee.table_name, :event_attendee_id
    rescue
    end
  end

  def self.down
    begin
      remove_index PersonEventAttendee.table_name, :person_id
      remove_index PersonEventAttendee.table_name, :event_attendee_id
      drop_table :person_event_attendees
    rescue
    end
  end
end
