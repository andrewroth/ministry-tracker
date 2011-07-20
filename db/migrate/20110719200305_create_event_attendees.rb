class CreateEventAttendees < ActiveRecord::Migration
  def self.up
    begin
      create_table :event_attendees do |t|
        t.integer :event_id
        t.string :email, :default => nil
        t.string :first_name, :default => nil
        t.string :last_name, :default => nil
        t.string :gender, :default => nil
        t.string :campus, :default => nil
        t.string :year_in_school, :default => nil
        t.string :home_phone, :default => nil
        t.string :cell_phone, :default => nil
        t.string :work_phone, :default => nil
        t.timestamps
      end
      add_index EventAttendee.table_name, :event_id
    rescue
    end
  end

  def self.down
    begin
      remove_index EventAttendee.table_name, :event_id
      drop_table :event_attendees
    rescue
    end
  end
end
