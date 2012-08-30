class AddSept2012ContactsTable < ActiveRecord::Migration
  def self.up
    create_table :sept2012_contacts, :primary_key => :id do |t|
      t.integer :id
      t.integer :connect_id
      t.integer :missionHub_id
      t.integer :campus_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :cellphone
      t.integer :status, :default => 0
      t.integer :result, :default => 0
      t.integer :nextStep, :default => 0
      t.string :priority
      t.integer :gender_id
      t.string :year
      t.string :degree
      t.string :residence
      t.integer :international, :default => 0
      t.string :craving
      t.string :magazine
      t.string :journey
      t.integer :interest, :default => 0
      t.integer :person_id
    end
  end

  def self.down
    drop_table :sept2012_contacts
  end
end
