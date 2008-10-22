class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table "people", :force => true do |t|
      t.column :user_id, :integer
      t.column "first_name",      :string
      t.column "last_name",       :string
      t.column "middle_name",     :string
      t.column "preferred_name",  :string
      t.column "gender",          :string
      t.column "year_in_school",  :string
      t.column "level_of_school", :string
      t.column "graduation_date", :string
      t.column "major",           :string
      t.column "minor",           :string
      t.column "birth_date",       :string
      t.column "bio",             :text
      t.column "image",           :string
      t.column "primary_campus",  :string
      t.column :created_at, :date
      t.column :updated_at, :date
    end
    add_index :people, [:user_id], :unique => true
  end

  def self.down
    remove_index :people, :column => :user_id
    drop_table :people
  end
end
