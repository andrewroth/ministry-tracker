class AddTimestampsAndCountToUserCodes < ActiveRecord::Migration
  def self.up
    change_table UserCode.table_name do |t|
      t.integer :click_count, :default => 0
      t.timestamps
    end
  end

  def self.down
    change_table UserCode.table_name do |t|
      t.remove :updated_at
      t.remove :created_at
      t.remove :click_count
    end
  end
end
