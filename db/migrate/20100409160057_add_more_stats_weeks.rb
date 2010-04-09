class AddMoreStatsWeeks < ActiveRecord::Migration
  NEW_WEEKS = [ { :week_id => 204, :week_endDate => "2010-04-10", :semester_id => 11, :month_id => 43 },
                { :week_id => 205, :week_endDate => "2010-04-17", :semester_id => 11, :month_id => 43 },
                { :week_id => 206, :week_endDate => "2010-04-24", :semester_id => 11, :month_id => 43 } ]

  def self.up
    NEW_WEEKS.each do |week|
      w = Week.new(week)
      w.week_id = week[:week_id]
      w.save
    end
  end

  def self.down
    NEW_WEEKS.each do |week|
      w = Week.find(week[:week_id])
      w.destroy
    end
  end
end
