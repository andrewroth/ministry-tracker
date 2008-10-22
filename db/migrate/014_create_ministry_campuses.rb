class CreateMinistryCampuses < ActiveRecord::Migration
  def self.up
    create_table :ministry_campuses do |t|
      t.column :ministry_id, :integer
      t.column :campus_id, :integer
    end
    add_index :ministry_campuses, [:ministry_id, :campus_id], :unique => true
  end

  def self.down
    remove_index :ministry_campuses, :column => :ministry_id
    drop_table :ministry_campuses
  end
end
