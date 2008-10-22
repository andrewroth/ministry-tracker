class CreateViews < ActiveRecord::Migration
  def self.up
    create_table :views do |t|
      t.column :title, :string
      t.column :ministry_id, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :views
  end
end
