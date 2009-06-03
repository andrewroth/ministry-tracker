class CreateCampusTerms < ActiveRecord::Migration
  def self.up
    create_table :campus_terms do |t|
      t.integer :term_id
      t.integer :campus_id
      t.date :start
      t.date :end
      t.date :verify_at

      t.timestamps
    end
  end

  def self.down
    drop_table :campus_terms
  end
end
