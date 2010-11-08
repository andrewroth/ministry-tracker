class CreateDismissedNotices < ActiveRecord::Migration
  def self.up
    create_table :dismissed_notices do |t|
      t.integer :person_id
      t.integer :notice_id

      t.timestamps
    end
  end

  def self.down
    drop_table :dismissed_notices
  end
end
