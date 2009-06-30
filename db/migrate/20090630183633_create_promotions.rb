class CreatePromotions < ActiveRecord::Migration
  def self.up
    create_table :promotions do |t|
      t.integer :person_id
      t.integer :promoter_id
      t.integer :ministry_involvement_id
      t.string :answer

      t.timestamps
    end
  end

  def self.down
    drop_table :promotions
  end
end
