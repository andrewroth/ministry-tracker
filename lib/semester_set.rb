module SemesterSet
  def set_current_and_next_semester
    @current_semester = Semester.current
    unless @current_semester
      Semester.create_default_semesters(2)
      @current_semester = Semester.current
    end
    # finding the next semester assumes that ids are sequential.  it can be changed to work
    # with non-sequential but is more work, so I'll assume it's sequential until we know
    # otherwise -AR
    @next_semester = Semester.find(:first, :conditions => [ "#{::Semester._(:id)} = ?", @current_semester.id + 1])
    unless @next_semester
      Semester.create_default_semesters(1) # need another year apparently
      @next_semester = Semester.find(:first, :conditions => [ "#{::Semester._(:id)} = ?", @current_semester.id + 1])
    end
  end
end
