class CreateLoginCodes < ActiveRecord::Migration
  def self.up
    create_table LoginCode.table_name do |t|
      t.boolean :acceptable, :default => true
      t.integer :times_used, :default => 0
      t.string :code
      t.datetime :expires_at, :default => nil
      t.timestamps
    end
    add_index LoginCode.table_name, :code
  end

  def self.down
    remove_index LoginCode.table_name, :code
    drop_table LoginCode.table_name
  end
end
