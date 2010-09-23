class MakeUserCodesPassText < ActiveRecord::Migration
  def self.up
    change_column UserCode.table_name, :pass, :text
  end

  def self.down
    change_column UserCode.table_name, :pass, :string
  end
end
