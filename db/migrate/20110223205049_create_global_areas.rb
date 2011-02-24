class CreateGlobalAreas < ActiveRecord::Migration
  def self.up
    create_table :global_areas do |t|
      t.string :area

      t.timestamps
    end
  end

  def self.down
    drop_table :global_areas
  end
end
