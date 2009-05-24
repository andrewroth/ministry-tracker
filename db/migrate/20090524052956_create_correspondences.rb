class CreateCorrespondences < ActiveRecord::Migration
  def self.up
    create_table :correspondences do |t|
      t.string :type
      t.integer :person_id
      t.datetime :last_sent_at
      t.boolean :acknowledged

      t.timestamps
    end
  end

  def self.down
    drop_table :correspondences
  end
end
