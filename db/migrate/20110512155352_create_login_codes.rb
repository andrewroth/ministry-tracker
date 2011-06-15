class CreateLoginCodes < ActiveRecord::Migration
  def self.up
    begin
      create_table LoginCode.table_name do |t|
        t.boolean :acceptable, :default => true
        t.integer :times_used, :default => 0
        t.string :code
        t.datetime :expires_at, :default => nil
        t.timestamps
      end
      add_index LoginCode.table_name, :code
    rescue
    end
  end

  def self.down
    begin
      remove_index LoginCode.table_name, :code
      drop_table LoginCode.table_name
    rescue
    end
  end
end
