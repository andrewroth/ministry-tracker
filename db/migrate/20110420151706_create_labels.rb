class CreateLabels < ActiveRecord::Migration
  def self.up
    create_table :labels do |t|
      t.string :content
      t.integer :priority, :default => 1

      t.timestamps
    end
  end

  def self.down
    drop_table :labels
  end
end
