module Pat
  def current_event_group_id
    #58   # 2010 projects
    75    # 2011 projects
  end

  def project_acceptance_totals(campus_ids, secondary_sort = {}, event_group_id = current_event_group_id)
    project_totals(campus_ids, "Acceptance", "accepted_count", event_group_id, secondary_sort)
  end

  def project_applying_totals(campus_ids, event_group_id = current_event_group_id)
    project_totals(campus_ids, "Applying", "applying_count", event_group_id)
  end

  def project_totals(campus_ids, type = "Acceptance", count_name = "accepted_count", event_group_id = current_event_group_id, secondary_sort = {})
    return [{}, {}] unless campus_ids.present?
    campus_ids << 0 unless campus_ids.include?(0)

    campuses = Campus.find(:all,
      :select => "#{Project.__(:title)} as project, #{Campus.__(:name)}, #{Campus.__(:abbrv)}, count(distinct(#{Profile.__(:id)})) as #{count_name}",
      :joins => %|
        INNER JOIN #{CampusInvolvement.table_name} ON #{Campus.__(:id)} = #{CampusInvolvement.__(:campus_id)}
          AND #{CampusInvolvement.__(:end_date)} IS NULL
          AND #{Campus.__(:id)} IN (#{campus_ids.join(',')})
        INNER JOIN #{Person.table_name} ON #{CampusInvolvement.__(:person_id)} = #{Person.__(:id)}
        INNER JOIN #{User.table_name} ON #{User.__(:id)} = #{Person.__(:user_id)}
        INNER JOIN #{Profile.table_name} ON #{User.__(:id)} = #{Profile.__(:viewer_id)} AND 
           #{Profile.__(:type)} = '#{type}'
        LEFT OUTER JOIN #{Project.table_name} ON #{Profile.__(:project_id)} = #{Project.__(:id)}
        INNER JOIN #{Appln.table_name} ON #{Profile.__(:appln_id)} = #{Appln.__(:id)}
        INNER JOIN #{Form.table_name} ON #{Appln.__(:form_id)} = #{Form.__(:id)} AND
           #{Form.__(:event_group_id)} = #{event_group_id}
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

  def projects_count_hash(event_group_id = current_event_group_id)
    projects_accepted = Profile.find(:all,
      :select => "#{Project.__(:title)} as title, count(#{Profile.__(:id)}) as accepted_count",
      :joins => %|
        LEFT OUTER JOIN #{Project.table_name} ON #{Profile.__(:project_id)} = #{Project.__(:id)}
        INNER JOIN #{Appln.table_name} ON #{Profile.__(:appln_id)} = #{Appln.__(:id)}
        INNER JOIN #{Form.table_name} ON #{Appln.__(:form_id)} = #{Form.__(:id)}
      |,
      :conditions => "#{Profile.__(:type)} = 'Acceptance' AND #{Form.__(:event_group_id)} = #{event_group_id}",
      :group => "#{Project.__(:id)}",
      :order => "accepted_count DESC"
    )
    projects_applying = Profile.find(:all,
      :select => "#{Project.__(:title)} as title, count(#{Profile.__(:id)}) as applying_count",
      :joins => %|
        LEFT OUTER JOIN #{Project.table_name} ON #{Profile.__(:project_id)} = #{Project.__(:id)}
        INNER JOIN #{Appln.table_name} ON #{Profile.__(:appln_id)} = #{Appln.__(:id)}
        INNER JOIN #{Form.table_name} ON #{Appln.__(:form_id)} = #{Form.__(:id)}
      |,
      :conditions => "#{Profile.__(:type)} = 'Applying' AND #{Form.__(:event_group_id)} = #{event_group_id}",
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
