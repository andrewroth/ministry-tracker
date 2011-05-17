class CreateGroupInvitations < ActiveRecord::Migration
  def self.up
    begin
      create_table GroupInvitation.table_name do |t|
        t.integer :group_id
        t.string :recipient_email
        t.integer :recipient_person_id, :default => nil
        t.integer :sender_person_id
        t.boolean :accepted, :default => nil
        t.integer :login_code_id
        t.timestamps
      end
      add_index GroupInvitation.table_name, :group_id
      add_index GroupInvitation.table_name, :login_code_id
    rescue
    end
  end

  def self.down
    begin
      remove_index GroupInvitation.table_name, :group_id
      remove_index GroupInvitation.table_name, :login_code_id
      drop_table GroupInvitation.table_name
    rescue
    end
  end
end
