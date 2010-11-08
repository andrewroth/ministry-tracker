class CreateNotices < ActiveRecord::Migration
  def self.up
    create_table :notices do |t|
      t.text :message
      t.boolean :live

      t.timestamps
    end
  end

  def self.down
    drop_table :notices
  end
end
