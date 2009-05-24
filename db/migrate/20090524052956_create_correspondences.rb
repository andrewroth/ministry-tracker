class CreateCorrespondences < ActiveRecord::Migration
  def self.up
    create_table :correspondences do |t|
      t.string :type
      t.integer :person_id
      t.datetime :last_sent_at
      t.boolean :acknowledged
      t.boolean :resend_if_not_acknowledged, :default => false
      t.float :resend_delay, :default => 24.hours.to_i
      t.integer :resend_count, :default => 3
      t.text :params

      t.timestamps
    end
  end

  def self.down
    drop_table :correspondences
  end
end
