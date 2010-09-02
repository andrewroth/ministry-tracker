class AddUserCode < ActiveRecord::Migration
  def self.up
    create_table UserCode.table_name do |t|
      t.integer :user_id
      t.string :code
      t.string :pass
    end
    add_index UserCode.table_name, :user_id
  end

  def self.down
    remove_index UserCode.table_name, :user_id
    drop_table UserCode.table_name
  end
end
