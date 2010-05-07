class AddMonthIdColumnToStatsSemesterReport < ActiveRecord::Migration
  def self.up
    add_column SemesterReport.table_name, :month_id, :integer, :limit => 4
  end

  def self.down
    remove_column SemesterReport.table_name, :month_id
  end
end
