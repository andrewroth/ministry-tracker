module SemesterSet
  def set_current_and_next_semester
    @current_semester = Semester.current
    unless @current_semester
      Semester.create_default_semesters(2)
      @current_semester = Semester.current
    end
    
    @next_semester = @current_semester.next_semester
    unless @next_semester
      Semester.create_default_semesters(1) # need another year apparently
      @next_semester = @current_semester.next_semester
    end
  end
end
