module Searching


  MAX_NUM_AUTOCOMPLETE_RESULTS = 5
  DEFAULT_NUM_SEARCH_RESULTS = 7

  # rank search result relevance, higher is more relevant and therefore higher in results
  SEARCH_RANK = {:person => {:first_name => 4, :last_name => 1, :ministry => 3},
                 :group  => {:name => 5, :ministry => 4, :semester_current => 4, :semester_next => 1, :involvement => 2}}


  def get_query
    @q = params["q"].squeeze(" ").strip if params["q"]
  end


  def search_groups(people)
    semester_current = Semester.current

    # rank group results based on these's people's involvements in them
    people_ids = people.nil? ? [] : people.collect {|p| p.id}
    people_ids_string = people_ids.empty? ? "''" : quote_string(people_ids.join(','))


    # I don't know a better way to sanitize the select statement...
    select_str = ActiveRecord::Base.__send__(:sanitize_sql,
       ["#{Group.__(:id)}, #{Group.__(:name)}, #{Group.__(:needs_approval)}, #{Campus.__(:short_desc)} AS campus_desc, #{Ministry.__(:name)} AS ministry_name, " +
        "#{Semester.__(:desc)} AS semester_desc, #{Semester.__(:start_date)} AS semester_start, #{Group.__(:day)}, #{Group.__(:start_time)}, #{Group.__(:end_time)}, " +
        "i.involvements, COUNT(#{GroupInvolvement.__(:person_id)}) AS num_members, " +

        # determine the rank for ordering of results
        "IF(#{Group.__(:name)} LIKE ?, #{SEARCH_RANK[:group][:name]}, 0) + " +
        "IF(#{Ministry.__(:name)} LIKE ?, #{SEARCH_RANK[:group][:ministry]}, 0) + " +
        "IF(#{Semester.__(:desc)} LIKE ?, #{SEARCH_RANK[:group][:semester_current]}, 0) + " +
        "IF(#{Semester.__(:desc)} LIKE ?, #{SEARCH_RANK[:group][:semester_next]}, 0) + " +
        "IF(i.involvements IS NOT NULL, #{SEARCH_RANK[:group][:involvement]}, 0) " +

        " AS rank ", "%#{@q}%", session[:search][:search_ministry_name], semester_current.desc, semester_current.next_semester.desc], '')


    joins_str = "LEFT JOIN #{Campus.table_name} ON #{Group.__(:campus_id)} = #{Campus.__(:id)} " +
                "LEFT JOIN #{Ministry.table_name} ON #{Group.__(:ministry_id)} = #{Ministry.__(:id)} " +
                "LEFT JOIN #{Semester.table_name} ON #{Group.__(:semester_id)} = #{Semester.__(:id)} " +
                "LEFT JOIN #{GroupInvolvement.table_name} ON #{Group.__(:id)} = #{GroupInvolvement.__(:group_id)} " +

                "LEFT JOIN (" +
                  "SELECT #{Group.__(:id)}, GROUP_CONCAT(DISTINCT #{GroupInvolvement.__(:person_id)} SEPARATOR ',') AS involvements " +
                  "FROM #{Group.table_name} INNER JOIN #{GroupInvolvement.table_name} " +
                  "ON #{Group.__(:id)} = #{GroupInvolvement.__(:group_id)} " +
                  "WHERE (#{GroupInvolvement._(:person_id)} IN (#{people_ids_string})) " +
                  "GROUP BY #{Group.__(:id)}" +
                ") AS i ON #{Group.__(:id)} = i.#{Group._(:id)} "


    groups = Group.paginate(:page => params[:page],
                   :per_page => params[:per_page],

                   :joins => joins_str,
                   :select => select_str,

                   :conditions => ["#{session[:search][:group_search_limit_condition]} AND (" +
                                   "involvements IS NOT NULL OR (" +
                                   "#{Group.__(:name, :group)} like ? " +
                                   "))",

                                   "%#{@q}%"],

                   :order => 'rank DESC, semester_start DESC',

                   :group => "#{Group.__(:id)}")

    groups

  end


  def search_people(query = @q)

    # I don't know a better way to sanitize the select statement...
    select_str = ActiveRecord::Base.__send__(:sanitize_sql,
       ["#{Person.__(:id)}, #{Person.__(:first_name)}, #{Person.__(:last_name)}, #{Person.__(:email)}, #{Person.__(:cell_phone)}, #{Person.__(:person_local_phone)}, #{Person.__(:person_phone)}, " +
        "#{ProfilePicture.__(:id)} AS profile_picture_id, #{Timetable.__(:id)} AS timetable_id, #{SchoolYear.__(:year_desc)}, " +
        "GROUP_CONCAT(DISTINCT #{Campus.__(:short_desc)} SEPARATOR ', ') AS campuses_concat, " +
        "GROUP_CONCAT(#{MinistryRole.__(:id)} SEPARATOR ',') AS staff_role_ids, " +
        "GROUP_CONCAT(DISTINCT #{Ministry.__(:name)} SEPARATOR ', ') AS ministries_concat, " +

        # determine the rank for ordering of results
        "IF(#{Person.__(:first_name)} LIKE ?, #{SEARCH_RANK[:person][:first_name]}, 0) + " +
        "IF(#{Person.__(:last_name)} LIKE ?, #{SEARCH_RANK[:person][:last_name]}, 0) + " +
        "IF(GROUP_CONCAT(DISTINCT #{Ministry.__(:name)} SEPARATOR ', ') LIKE ?, #{SEARCH_RANK[:person][:ministry]}, 0) " +
        " AS rank", "#{query}%", "#{query}%", session[:search][:search_ministry_name] ], '')


    people = Person.paginate(:page => params[:page],
              :per_page => params[:per_page],
              :joins => "LEFT JOIN #{CampusInvolvement.table_name} ON #{CampusInvolvement.__(:person_id)} = #{Person.__(:person_id)} AND #{CampusInvolvement.__(:end_date)} IS NULL " +
                        "LEFT JOIN #{Campus.table_name} ON #{Campus.__(:campus_id)} = #{CampusInvolvement.__(:campus_id)} " +
                        "LEFT JOIN #{ProfilePicture.table_name} ON #{ProfilePicture.__(:person_id)} = #{Person.__(:person_id)} " +
                        "LEFT JOIN #{MinistryInvolvement.table_name} ON #{MinistryInvolvement.__(:person_id)} = #{Person.__(:person_id)} AND #{MinistryInvolvement.__(:end_date)} IS NULL " +

                        # need this to find their staff roles to see if they are in fact a staff
                        "LEFT JOIN #{MinistryRole.table_name} ON #{MinistryRole.__(:id)} = #{MinistryInvolvement.__(:ministry_role_id)} AND #{MinistryRole.__(:type)} = 'StaffRole' " +

                        # need this to find their ministries to display instead of campuses if they're staff, but skip the P2C and C4C ministries
                        "LEFT JOIN #{Ministry.table_name} ON #{Ministry.__(:id)} = #{MinistryInvolvement.__(:ministry_id)} AND #{Ministry.__(:id)} > 2 " +

                        "LEFT JOIN #{Timetable.table_name} ON #{Timetable.__(:person_id)} = #{Person.__(:person_id)} " +
                        "LEFT JOIN #{CimHrdbPersonYear.table_name} ON #{CimHrdbPersonYear.__(:person_id)} = #{Person.__(:person_id)} " +
                        "LEFT JOIN #{SchoolYear.table_name} ON #{CimHrdbPersonYear.__(:year_id)} = #{SchoolYear.__(:year_id)} ",

              :select => select_str,

              :conditions => ["#{session[:search][:person_search_limit_condition]} AND (" +
                              "concat(#{_(:first_name, :person)}, \" \", #{_(:last_name, :person)}) like ? " +
                              "or #{_(:first_name, :person)} like ? " +
                              "or #{_(:last_name, :person)} like ? " +
                              "or #{_(:email, :person)} like ? " +
                              "or #{Person.table_name}.#{_(:id, :person)} like ? " +
                              ")",
                              "#{query}%", "#{query}%", "#{query}%", "%#{query}%", "%#{query}%"],

              :order => 'rank DESC',

              :group => "#{Person.__(:id)}")

    people

  end


  def search_web(query = @q)
    num = params[:per_page].present? ? params[:per_page].to_i : DEFAULT_NUM_SEARCH_RESULTS.to_i
    start = params[:page].present? ? (params[:page].to_i*num)-num : 0
    config = google_search_appliance_config.merge({:num => num, :start => start})

    service_uri = config.delete(:url)
    service_uri += "#{service_uri.include?('?') ? '&' : '?'}q=#{CGI::escape(query)}"
    service_uri = construct_cas_proxy_authenticated_service_url(service_uri, config)

    @gsa_results_unauthenticated = true unless service_uri.include?("ticket=")

    g = Gasohol::Search.new(google_search_appliance_config)
    g.search_request_string(service_uri)
  end


  def setup_my_ministry_and_campus_ids
    if get_person

      if is_staff_somewhere

        # return anyone at or underneath a ministry that I'm involved in or one of those ministry's campuses

        ministries = @my.ministries.collect {|m| m.self_plus_descendants }.flatten.uniq
        @ministry_search_ids = ministries.collect {|m| m.id}

        campuses = ministries.collect {|m| m.campuses}.flatten.uniq
        @campus_search_ids ||= campuses.collect {|c| c.id}

      else # is student

        # return anyone at a campus I'm involved in or a ministry I'm involved in

        @ministry_search_ids = @my.ministries.collect {|ministry| ministry.id}

        @campus_search_ids ||= @my.campuses.collect {|c| c.id}
      end

      @ministry_search_ids = [0] if (@ministry_search_ids.blank? || @ministry_search_ids.empty?)
      @campus_search_ids = [0] if (@campus_search_ids.blank? || @campus_search_ids.empty?)

    end
  end


  def get_involvement_limit_condition_for_person_search
    setup_my_ministry_and_campus_ids unless @ministry_search_ids && @campus_search_ids

    # don't return people who have no involvements and don't return people who aren't within my ministry and campus involvements
    "(#{MinistryInvolvement.__(:id)} IS NOT NULL or #{CampusInvolvement.__(:id)} IS NOT NULL) AND " +
    "(#{MinistryInvolvement.__(:ministry_id)} in (#{quote_string(@ministry_search_ids.join(','))}) OR #{CampusInvolvement.__(:campus_id)} in (#{quote_string(@campus_search_ids.join(','))})) "
  end


  def get_involvement_limit_condition_for_group_search
    setup_my_ministry_and_campus_ids unless @ministry_search_ids && @campus_search_ids

    # don't return groups which aren't within my ministry and campus involvements
    "(#{Ministry.__(:id)} IS NOT NULL or #{Campus.__(:id)} IS NOT NULL) AND " +
    "(#{Ministry.__(:id)} in (#{quote_string(@ministry_search_ids.join(','))}) OR #{Campus.__(:id)} in (#{quote_string(@campus_search_ids.join(','))})) "
  end


  def setup_session_for_search
    @filter_out_mentored = false
    @search_for_mentor = false

    if logged_in? # necessary because we skip standard login stack for performance gain
      session[:search] ||= {}

      session[:search][:person_search_limit_condition] ||= get_involvement_limit_condition_for_person_search
      session[:search][:group_search_limit_condition] ||= get_involvement_limit_condition_for_group_search

      if session[:search][:search_ministry_name].nil? || session[:search][:search_ministry_id].nil? || session[:search][:search_ministry_id] != session[:ministry_id]
        session[:search][:search_ministry_name] = get_ministry.name
        session[:search][:search_ministry_id] = session[:ministry_id]
      end

      session[:search][:authorized_to_search_people] ||= (authorized?(:people, :search) && authorized?(:show, :people) && authorized?(:search, :people))
      session[:search][:authorized_to_search_groups] ||= (authorized?(:groups, :search) && authorized?(:show, :groups))
      session[:search][:authorized_to_search_web] ||= authorized?(:web, :search)

      session[:search][:search_prepared] ||= true
    end
  end


  def set_num_results_per_page
    @num_results_per_page = DEFAULT_NUM_SEARCH_RESULTS
    params[:per_page] = @num_results_per_page
  end

end
