class CreateTerms < ActiveRecord::Migration
  def self.up
    create_table :terms do |t|
      t.string :name
      t.boolean :default
      t.date :start
      t.date :end
      t.integer :ministry_school_years_id
      t.date :verify_at

      t.timestamps
    end
  end

  def self.down
    drop_table :terms
  end
end
