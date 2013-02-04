class CreateContacts < ActiveRecord::Migration
  def self.up
    create_table :contacts do |t|
      t.string :first_name
      t.string :last_name
      t.string :mobile_phone
      t.string :email
      t.integer :next_step
      t.string :what_i_am_trusting_god_to_do_next
      t.boolean :active
      t.boolean :private, :default => true
      t.integer :campus_id
      t.integer :sept_2012_survey_contact_id
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :contacts
  end
end
