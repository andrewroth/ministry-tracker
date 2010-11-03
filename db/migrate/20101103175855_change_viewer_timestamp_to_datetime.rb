class ChangeViewerTimestampToDatetime < ActiveRecord::Migration
  def self.up
    change_column User.table_name, User._(:last_login), :datetime
  end

  def self.down
    change_column User.table_name, User._(:last_login), :date
  end
end
