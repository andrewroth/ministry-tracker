class CreateUserGroups < ActiveRecord::Migration
  def self.up
    create_table :user_groups do |t|
      t.column :name, :string
      t.column :created_at, :date
    end
  end

  def self.down
    drop_table :user_groups
  end
end
