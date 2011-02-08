class MakeUsercodePassBlob < ActiveRecord::Migration
  def self.up
    change_column UserCode.table_name, :pass, :blob
  end

  def self.down
    change_column UserCode.table_name, :pass, :text
  end
end
