class CreateGlobalCountries < ActiveRecord::Migration
  def self.up
    create_table :global_countries do |t|
      t.string :name
      t.integer :global_area_id

      t.timestamps
    end
  end

  def self.down
    drop_table :global_countries
  end
end
