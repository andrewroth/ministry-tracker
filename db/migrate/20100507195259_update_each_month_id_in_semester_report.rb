class UpdateEachMonthIdInSemesterReport < ActiveRecord::Migration
  def self.month_id_corresponding_to_semester_id(semester_id, hsh)
    hsh ||= Hash.new
    if !(hsh.has_key?(semester_id))
      hsh[semester_id] = Month.find(:all, :conditions => { :semester_id => semester_id }, :order => :month_number).last.id
    end
    hsh[semester_id]
  end

    

  def self.up
    hsh = Hash.new
    SemesterReport.all.each do | sr |
      sr[:month_id] = self.month_id_corresponding_to_semester_id(sr[:semester_id], hsh)
      sr.save!
    end
  end

  def self.down
    SemesterReport.all.each do | sr |
      sr[:month_id] = nil
      sr.save!
    end
  end
end
