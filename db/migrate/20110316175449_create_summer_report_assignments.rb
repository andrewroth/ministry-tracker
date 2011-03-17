class CreateSummerReportAssignments < ActiveRecord::Migration
  
  ASSIGNMENTS = [
    {:assignment => "MPD/MPM"},
    {:assignment => "Summer Project"},
    {:assignment => "Vacation"},
    {:assignment => "Sabatical"},
    {:assignment => "IBS/Seminary"},
    {:assignment => "Special Project"},
    {:assignment => "Regular Job"},
    {:assignment => "Other"}
  ]

  def self.up
    create_table SummerReportAssignment.table_name do |t|
      t.string :assignment

      t.timestamps
    end

    ASSIGNMENTS.each {|assignment| SummerReportAssignment.create!(assignment)}
  end

  def self.down
    drop_table SummerReportAssignment.table_name
  end
end
