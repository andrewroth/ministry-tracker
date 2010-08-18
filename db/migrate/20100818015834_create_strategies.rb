class CreateStrategies < ActiveRecord::Migration
  def self.up
    create_table Strategy.table_name do |t|
      t.string :name
      t.string :abbrv
    end
  end

  def self.down
    drop_table Strategy.table_name
  end
end
