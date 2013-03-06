module Pat
  def current_event_group_id
    # 58    # 2010 projects
    # 75    # 2011 projects
    # 82    # 2012 projects
    94    # 2013 projects
  end

  def current_project_ids
    Pat::EventGroup.find(current_event_group_id).projects.collect(&:id) + [
      345, # Gain 2013 Haiti Spring Break
      365, # Gain 2013 Mukti Mission
      349, # Gain 2013 Benin
    ]
  end

  def project_acceptance_totals(campus_ids, secondary_sort = {}, project_ids = current_project_ids)
    project_totals(campus_ids, "Acceptance", "accepted_count", project_ids, secondary_sort)
  end

  def project_applying_totals(campus_ids, project_ids = current_project_ids)
    project_totals(campus_ids, "Applying", "applying_count", project_ids)
  end

  def project_totals(campus_ids, type = "Acceptance", count_name = "accepted_count", project_ids = current_project_ids, secondary_sort = {})
    return [{}, {}] unless campus_ids.present?
    campus_ids << 0 unless campus_ids.include?(0)
    project_ids << 0 # so that we don't get a syntax error if no projects are passed in

    campuses = Campus.find(:all,
      :select => "#{Project.__(:title)} as project, #{Campus.__(:name)}, #{Campus.__(:abbrv)}, count(distinct(#{Profile.__(:id)})) as #{count_name}",
      :joins => %|
        INNER JOIN #{CampusInvolvement.table_name} ON #{Campus.__(:id)} = #{CampusInvolvement.__(:campus_id)}
          AND #{CampusInvolvement.__(:end_date)} IS NULL
          AND #{Campus.__(:id)} IN (#{campus_ids.join(',')})
        INNER JOIN #{Person.table_name} ON #{CampusInvolvement.__(:person_id)} = #{Person.__(:id)}
        INNER JOIN #{Access.table_name} ON #{Person.__(:id)} = #{Access.__(:person_id)}
        INNER JOIN #{User.table_name} ON #{Access.__(:viewer_id)} = #{User.__(:id)}
        INNER JOIN #{Profile.table_name} ON #{User.__(:id)} = #{Profile.__(:viewer_id)} AND
           #{Profile.__(:type)} = '#{type}'
        INNER JOIN #{Project.table_name} ON #{Profile.__(:project_id)} = #{Project.__(:id)} AND
           #{Project.__(:id)} IN (#{project_ids.join(',')})
      |,
      :group => "#{Project.__(:id)}, #{Campus.__(:id)}",
      :order => "#{Campus.__(:name)} ASC, #{count_name} DESC"
    )

    results_by_project = ActiveSupport::OrderedHash.new
    results_by_campus = ActiveSupport::OrderedHash.new
    campuses.each do |campus|
      results_by_project[campus.project] ||= ActiveSupport::OrderedHash.new
      results_by_project[campus.project][campus.abbrv] = campus.send(count_name)
      results_by_project[campus.project][:total] ||= 0
      results_by_project[campus.project][:total] += campus.send(count_name).to_i

      results_by_campus[campus.abbrv] ||= ActiveSupport::OrderedHash.new
      results_by_campus[campus.abbrv][campus.project] = campus.send(count_name)
      results_by_campus[campus.abbrv][:total] ||= 0
      results_by_campus[campus.abbrv][:total] += campus.send(count_name).to_i
    end
    # this can probably be done in sql somehow, but I can code it here way faster
    results_by_campus2 = ActiveSupport::OrderedHash.new
    results_by_campus.collect{|k,v| [ k, v ]}.sort{ |a, b|
      k1, v1 = a
      k2, v2 = b
      diff = v2[:total].to_i <=> v1[:total].to_i
      if diff != 0
        diff
      else
        if secondary_sort
          s1 = (secondary_sort[k1] && secondary_sort[k1][:total]) || 0
          s2 = (secondary_sort[k2] && secondary_sort[k2][:total]) || 0
          s2 <=> s1
        else
          0
        end
      end
    }.each do |k,v|
      results_by_campus2[k] = v
    end

    [ results_by_campus2, results_by_project ]
  end

  def projects_count_hash(project_ids = current_project_ids)
    project_ids << 0 # so that we don't get a syntax error if no projects are passed in
    projects_accepted = Profile.find(:all,
      :select => "#{Project.__(:title)} as title, count(#{Profile.__(:id)}) as accepted_count",
      :joins => %|
        INNER JOIN #{Project.table_name} ON #{Profile.__(:project_id)} = #{Project.__(:id)} AND
          #{Project.__(:id)} IN (#{project_ids.join(',')})
      |,
      :conditions => "#{Profile.__(:type)} = 'Acceptance'",
      :group => "#{Project.__(:id)}",
      :order => "accepted_count DESC"
    )
    projects_applying = Profile.find(:all,
      :select => "#{Project.__(:title)} as title, count(#{Profile.__(:id)}) as applying_count",
      :joins => %|
        INNER JOIN #{Project.table_name} ON #{Profile.__(:project_id)} = #{Project.__(:id)} AND
          #{Project.__(:id)} IN (#{project_ids.join(',')})
      |,
      :conditions => "#{Profile.__(:type)} = 'Applying'",
      :group => "#{Project.__(:id)}",
      :order => "applying_count DESC"
    )

    results = ActiveSupport::OrderedHash.new
    totals = { :accepted => 0, :applying => 0 }
    projects_accepted.each do |project|
      totals[:accepted] += project.accepted_count.to_i
      results[project.title] ||= {}
      results[project.title][:accepted] = project.accepted_count
    end
    projects_applying.each do |project|
      totals[:applying] += project.applying_count.to_i
      results[project.title] ||= {}
      results[project.title][:applying] = project.applying_count
    end
    results[:totals] = totals
    results
  end
end
