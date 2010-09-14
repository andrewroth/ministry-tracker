class MoveRegionalNationalToOther < ActiveRecord::Migration
 COPY_FROM_CAMPUS = { :campus_shortDesc => "Reg/Nat" }
 COPY_TO_CAMPUS = { :campus_shortDesc => "Other" }

  def self.find_campus(campus)
    Campus.find(:first, :conditions => { :campus_shortDesc => campus[:campus_shortDesc] } )
  end
  
  def self.move_stats(stats_model, campus_from, campus_to)
    unless campus_from.nil? || campus_to.nil?
      wr_list = stats_model.find :all, :conditions => { :campus_id => campus_from.id }
      wr_list.each do |wr|
        wr.campus_id = campus_to.id
        wr.save!
      end
    end
  end
  
  def self.up
    campus_from = find_campus(COPY_FROM_CAMPUS)
    campus_to = find_campus(COPY_TO_CAMPUS)
    move_stats(WeeklyReport, campus_from, campus_to)
    move_stats(Prc, campus_from, campus_to)
    move_stats(MonthlyReport, campus_from, campus_to)
    move_stats(SemesterReport, campus_from, campus_to)
  end

  def self.down
  end
end
