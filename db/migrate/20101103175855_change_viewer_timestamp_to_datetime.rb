class ChangeViewerTimestampToDatetime < ActiveRecord::Migration
  def self.up
    change_column User.table_name, User._(:last_login), :datetime, :null => true
  end

  def self.down
    change_column User.table_name, User._(:last_login), :date, :null => false
  end
end
