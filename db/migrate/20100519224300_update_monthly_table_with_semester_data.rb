class UpdateMonthlyTableWithSemesterData < ActiveRecord::Migration
  def self.up
    Rake::Task['cmt:update_monthly_report'].invoke
  end

  def self.down
  end
end
