class CreateEmailTemplates < ActiveRecord::Migration
  def self.up
    create_table :email_templates, :primary_key => :id do |t|
      t.integer :id, :limit => 11
      t.integer :correspondence_type_id
      t.string :outcome_type
      t.string :subject, :limit => 255, :null => false
      t.string :from, :limit => 255, :null => false
      t.string :bcc, :limit => 255
      t.string :cc, :limit => 255
      t.text :body, :null => false
      t.text :template
      t.timestamps
    end
  end

  def self.down
    drop_table :email_templates
  end
end
