class CreateContactsPeople < ActiveRecord::Migration
  def self.up
    create_table :contacts_people, :id => false do |t|
      t.column :person_id, :integer
      t.column :contact_id, :integer
    end
  end

  def self.down
    drop_table :contacts_people
  end
end
