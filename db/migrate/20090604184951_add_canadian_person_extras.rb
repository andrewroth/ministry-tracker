class AddCanadianPersonExtras < ActiveRecord::Migration
  def self.up
    create_table :person_extras, :primary_key => :id do |t|
      t.integer :person_id
      t.string :major
      t.string :minor
      t.string :url
      t.string :staff_notes
      t.string :updated_at
      t.string :updated_by

      # perm address extra
      t.date :perm_start_date
      t.date :perm_end_date
      t.string :perm_dorm
      t.string :perm_room
      t.string :perm_alternate_phone
      
      # curr address extra
      t.date :curr_start_date
      t.date :curr_end_date
      t.string :curr_dorm
      t.string :curr_room
      # current alternate phone is mapped to cell_phone
    end
    add_index :person_extras, :person_id
  end

  def self.down
    remove_index :person_extras, :person_id
    drop_table :person_extras
  end
end
