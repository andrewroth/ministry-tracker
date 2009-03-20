class CreateSearches < ActiveRecord::Migration
  def self.up
    create_table :searches do |t|
      t.integer :person_id
      t.text :options, :query, :tables
      t.boolean :saved
      t.string :name, :order, :description
      t.timestamps
    end
  end

  def self.down
    drop_table :searches
  end
end
