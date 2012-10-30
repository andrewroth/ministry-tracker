class CopyActivityPrcToStatsPrc < ActiveRecord::Migration
  def self.up
    prc_activities_grouped = Activity.find(:all, :conditions => { :activity_type_id => 4 }).group_by(&:reportable_id)

    prc_activities_grouped.each do |a|
      a = a[1][0]
      Prc.new({
          :prc_firstName => a.reportable.first_name,
          :prcMethod_id => 10,
          :prc_witnessName => a.reporter.full_name,
          :semester_id => Semester.find_semester_from_date(a.created_at).id,
          :campus_id => a.reportable.campus_id,
          :prc_notes => "Imported from September Launch Follow-up",
          :prc_date => a.created_at
        }).save
    end
  end

  def self.down
  end
end
