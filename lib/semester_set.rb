module SemesterSet
    def set_current_and_next_semester
    @current_semester = Semester.current
    unless @current_semester
      Semester.create_default_semesters(1)
      @current_semester = Semester.current
    end
    
    @next_semester = @current_semester.next_semester
    while @next_semester.nil?
      Semester.create_default_semesters(1) # need another year apparently
      @current_semester = Semester.current
      @next_semester = @current_semester.next_semester
    end
  end
end
