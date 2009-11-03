class CreateInvolvementHistories < ActiveRecord::Migration
  def self.up
    create_table :involvement_histories do |t|
      t.integer :person_id
      t.date :start_date
      t.date :end_date
      t.integer :campus_id
      t.integer :school_year_id
      t.integer :ministry_id
      t.integer :ministry_role_id
      t.boolean :admin

      t.timestamps
    end
  end

  def self.down
    drop_table :involvement_histories
  end
end
