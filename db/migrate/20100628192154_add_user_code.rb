class AddUserCode < ActiveRecord::Migration
  def self.up
    create_table :user_codes do |t|
      t.integer :user_id
      t.string :code
      t.string :pass
    end
    add_index :user_codes, :user_id
  end

  def self.down
    remove_index :user_codes, :user_id
    drop_table :user_codes
  end
end
