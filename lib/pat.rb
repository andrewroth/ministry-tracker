module Pat
  def current_event_group_id
    58
  end

  def project_totals(campus_ids, event_group_id = current_event_group_id)
    return [] unless campus_ids.present?
    campus_ids << 0 unless campus_ids.include?(0)

    campuses = Campus.find(:all,
      :select => "#{Project.__(:title)} as project, #{Campus.__(:name)}, #{Campus.__(:abbrv)}, count(#{Profile.__(:id)}) as accepted_count",
      :joins => %|
        INNER JOIN #{CampusInvolvement.table_name} ON #{Campus.__(:id)} = #{CampusInvolvement.__(:campus_id)}
          AND #{Campus.__(:id)} IN (#{campus_ids.join(',')})
        INNER JOIN #{Person.table_name} ON #{CampusInvolvement.__(:person_id)} = #{Person.__(:id)}
        INNER JOIN #{Access.table_name} ON #{Person.__(:id)} = #{Access.__(:person_id)}
        INNER JOIN #{User.table_name} ON #{Access.__(:viewer_id)} = #{User.__(:id)}
        INNER JOIN #{Profile.table_name} ON #{User.__(:id)} = #{Profile.__(:viewer_id)} AND 
           #{Profile.__(:type)} = 'Acceptance'
        INNER JOIN #{Project.table_name} ON #{Profile.__(:project_id)} = #{Project.__(:id)} AND 
           #{Project.__(:event_group_id)} = #{event_group_id}
      |,
      :group => "#{Project.__(:id)}, #{Campus.__(:id)}",
      :order => "#{Campus.__(:name)} ASC, accepted_count DESC"
    )

    results_by_project = ActiveSupport::OrderedHash.new
    results_by_campus = ActiveSupport::OrderedHash.new
    campuses.each do |campus|
      results_by_project[campus.project] ||= ActiveSupport::OrderedHash.new
      results_by_project[campus.project][campus.abbrv] = campus.accepted_count
      results_by_project[campus.project][:total] ||= 0
      results_by_project[campus.project][:total] += campus.accepted_count.to_i

      results_by_campus[campus.abbrv] ||= ActiveSupport::OrderedHash.new
      results_by_campus[campus.abbrv][campus.project] = campus.accepted_count
      results_by_campus[campus.abbrv][:total] ||= 0
      results_by_campus[campus.abbrv][:total] += campus.accepted_count.to_i
    end
    # this can probably be done in sql somehow, but I can code it here way faster
    results_by_campus2 = ActiveSupport::OrderedHash.new
    results_by_campus.collect{|k,v| [ k, v ]}.sort{ |a, b| k1, v1 = a; k2, v2 = b; v2[:total].to_i <=> v1[:total].to_i }.each do |k,v|
      results_by_campus2[k] = v
    end

    [ results_by_campus2, results_by_project ]
  end

  def projects_count_hash(event_group_id = current_event_group_id)
    projects = Project.find(:all,
      :select => "#{Project.__(:title)} as project, count(#{Profile.__(:id)}) as accepted_count",
      :joins => %|
        INNER JOIN #{Profile.table_name} ON #{Profile.__(:project_id)} = #{Project.__(:id)} AND 
           #{Project.__(:event_group_id)} = #{event_group_id}
      |,
      :conditions => "#{Profile.__(:type)} = 'Acceptance'",
      :group => "#{Project.__(:id)}",
      :order => "accepted_count DESC"
    )

    results = ActiveSupport::OrderedHash.new
    projects.each do |project|
      results[project.project] = project.accepted_count
    end
    results
  end
end
