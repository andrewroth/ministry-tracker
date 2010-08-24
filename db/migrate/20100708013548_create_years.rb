class CreateYears < ActiveRecord::Migration
  def self.up
    create_table Year.table_name do |t|
      t.string :desc

      t.timestamps
    end
  end

  def self.down
    drop_table Year.table_name
  end
end
