class AddTableStatsAnnualGoalsReport < ActiveRecord::Migration
  def self.up
    create_table AnnualGoalsReport.table_name, :primary_key => :annualGoalsReport_id do |t|
      t.integer :annualGoalsReport_id
      t.integer :campus_id
      t.integer :year_id
      t.integer :annualGoalsReport_studInMin, :default => 0
      t.integer :annualGoalsReport_sptMulti, :default => 0
      t.integer :annualGoalsReport_firstYears, :default => 0
      t.integer :annualGoalsReport_summitWent, :default => 0
      t.integer :annualGoalsReport_wcWent, :default => 0
      t.integer :annualGoalsReport_projWent, :default => 0
      t.integer :annualGoalsReport_spConvTotal, :default => 0
      t.integer :annualGoalsReport_gosPresTotal, :default => 0
      t.integer :annualGoalsReport_hsPresTotal, :default => 0
      t.integer :annualGoalsReport_prcTotal, :default => 0
      t.integer :annualGoalsReport_integBelievers, :default => 0
      t.integer :annualGoalsReport_lrgEventAttend, :default => 0  
    end
  end
 
  def self.down
    drop_table AnnualGoalsReport.table_name
  end
end