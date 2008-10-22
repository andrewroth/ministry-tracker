class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :person_id, :integer
      t.column :username, :string
      t.column :password, :string
      t.column :last_login, :datetime
      t.column :system_admin, :boolean
      t.column :remember_token, :string
      t.column :remember_token_expires_at, :datetime
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    add_index :users, [:person_id], :unique => true
  end

  def self.down
    remove_index :users, :column => :person_id
    drop_table :users
  end
end
