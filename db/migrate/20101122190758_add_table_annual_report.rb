class AddTableAnnualReport < ActiveRecord::Migration
  def self.up
    create_table AnnualReport.table_name, :primary_key => :annualReport_id do |t|
      t.integer :annualReport_id
      t.integer :campus_id
      t.integer :year_id
      t.integer :annualReport_lnz_avgPrayer, :default => 0
      t.integer :annualReport_lnz_numFrosh, :default => 0
      t.integer :annualReport_lnz_totalStudentInDG, :default => 0
      t.integer :annualReport_lnz_totalSpMult, :default => 0
      t.integer :annualReport_lnz_totalCoreStudents, :default => 0
    end
  end
  
  def self.down
    drop_table AnnualReport.table_name
  end
end
