class CreateMinistryRoles < ActiveRecord::Migration
  def self.up
    create_table :ministry_roles do |t|
      t.column :ministry_id, :integer
      t.column :name, :string
      t.column :created_at, :date
    end
    add_index :ministry_roles, :ministry_id
  end

  def self.down
    remove_index :ministry_roles, :ministry_id
    drop_table :ministry_roles
  end
end
