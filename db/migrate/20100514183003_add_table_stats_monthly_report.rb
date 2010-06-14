class AddTableStatsMonthlyReport < ActiveRecord::Migration
  def self.up
    create_table MonthlyReport.table_name, :primary_key => :monthlyreport_id do |t|
      t.integer :monthlyreport_id
      t.integer :campus_id
      t.integer :month_id
      t.integer :monthlyreport_avgPrayer, :default => 0
      t.integer :monthlyreport_numFrosh, :default => 0
      t.integer :monthlyreport_eventSpirConversations, :default => 0
      t.integer :monthlyreport_eventGospPres, :default => 0
      t.integer :monthlyreport_mediaSpirConversations, :default => 0
      t.integer :monthlyreport_mediaGospPres, :default => 0
      t.integer :monthlyreport_totalCoreStudents, :default => 0
      t.integer :monthlyreport_totalStudentInDG, :default => 0
      t.integer :monthlyreport_totalSpMult, :default => 0
    end
  end
 
  def self.down
    drop_table MonthlyReport.table_name
  end
end
