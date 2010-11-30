namespace :hrdb do
  namespace :staff do
    task :cleanup => :environment do
      duplicates = {}
      Staff.all.each do |staff|
        duplicates[staff.person_id] ||= [ ]
        duplicates[staff.person_id] << staff.id
      end

      duplicates.each_pair do |person_id, staffs|
        if staffs.length > 1
          p = Person.find(person_id)
          puts "Person #{person_id} #{p.full_name}"
          puts "keep " + Staff.find(staffs.first).inspect
          Staff.find(staffs[1..staffs.length]).each do |staff|
            puts "destroy " + staff.inspect
            staff.destroy
          end
        end
      end
    end
  end

  namespace :migrate do
    task :assignments => :environment do
      current_student_assignment_status_id = ::Assignmentstatus.find_by_assignmentstatus_desc("Current Student").try(:id)
      unknown_assignment_status_id = ::Assignmentstatus.find_by_assignmentstatus_desc("Unknown Status").try(:id)
      unknown_school_year = SchoolYear.find 9

      if ENV['eg'].present?
        people = Person.find(:all, :select => "#{Person.__(:id)}, #{Person.__(:person_fname)}, #{Person.__(:person_lname)}", :joins => %|
          INNER JOIN #{Access.table_name} ON #{Person.__(:id)} = #{Access.__(:person_id)}
          INNER JOIN #{User.table_name} ON #{Access.__(:viewer_id)} = #{User.__(:id)}
          INNER JOIN #{Pat::Profile.table_name} ON #{User.__(:id)} = #{Pat::Profile.__(:viewer_id)}
          INNER JOIN #{Pat::Project.table_name} ON #{Pat::Profile.__(:project_id)} = #{Pat::Project.__(:id)} AND 
                     #{Pat::Project.__(:event_group_id)} = #{ENV['eg']}
        |)
      else
        throw "need eg="
      end

      #Person.all.each do |person|
      #[ Person.find(13822) ].each do |person|
      people.each do |person|
        next if person.campus_involvements.present?

        # look for current assignment first
        if current_student_assignment_status_id
          c = person.assignments.find_by_assignmentstatus_id current_student_assignment_status_id, :include => :campus
        end

        if !c && unknown_assignment_status_id
          u = person.assignments.find_by_assignmentstatus_id unknown_assignment_status_id, :include => :campus
        end

        a = c || u

        if a && a.campus
          year_orig = person.cim_hrdb_school_years.first
          year = year_orig || unknown_school_year
          puts "Person #{person.full_name} has student assignment to #{a.campus.try(:abbrv)} year #{year_orig.try(:year_desc)}"
          m = a.campus.derive_ministry
          if m
            ci = person.campus_involvements.find_or_create_by_campus_id(a.campus.id)
            ci.ministry_id = m.id
            ci.campus_id ||= a.campus.id
            ci.start_date ||= Date.today
            mi = ci.find_or_create_ministry_involvement
            puts "    -> #{m.name} #{mi.ministry_role.name}"
          end
        end

      end
    end
  end
end

