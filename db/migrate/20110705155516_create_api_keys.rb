class CreateApiKeys < ActiveRecord::Migration
  def self.up
    begin
      create_table :api_keys do |t|
        t.integer :user_id
        t.integer :login_code_id
        t.string :purpose

        t.timestamps
      end
    rescue
    end
  end

  def self.down
    begin
      drop_table :api_keys
    rescue
    end
  end
end
