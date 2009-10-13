class CreateEmails < ActiveRecord::Migration
  def self.up
    create_table :emails do |t|
      t.string :salutation, :default => 'Hi'
      t.string :subject
      t.text :body, :people_ids, :missing_address_ids
      t.integer :search_id, :sender_id
      t.timestamps
    end
  end

  def self.down
    drop_table :emails
  end
end
