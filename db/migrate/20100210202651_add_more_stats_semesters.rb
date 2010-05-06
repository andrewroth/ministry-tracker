class AddMoreStatsSemesters < ActiveRecord::Migration

  NEW_SEMESTERS = [ { :semester_id => 12, :semester_desc => "Summer 2010", :semester_startDate => "2010-05-01", :year_id => 4 },
                    { :semester_id => 13, :semester_desc => "Fall 2010",   :semester_startDate => "2010-09-01", :year_id => 5 },
                    { :semester_id => 14, :semester_desc => "Winter 2011", :semester_startDate => "2011-01-01", :year_id => 5 },
                    { :semester_id => 15, :semester_desc => "Summer 2011", :semester_startDate => "2011-05-01", :year_id => 5 } ]

  def self.up
    NEW_SEMESTERS.each do |semester|
      s = Semester.find :first, :conditions => semester
      unless s
        s = Semester.new semester
        s.semester_id = semester[:semester_id]
        s.save
      end
    end
  end

  def self.down
    NEW_SEMESTERS.each do |semester|
      s = Semester.find(semester[:semester_id])
      s.destroy
    end
  end
end
