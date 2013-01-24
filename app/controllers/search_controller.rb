class SearchController < ApplicationController
  unloadable

  include Searching

  skip_standard_login_stack :only => [:autocomplete, :autocomplete_mentors, :autocomplete_mentees, :prepare]

  before_filter :setup_session_for_search, :only => [:index, :people, :groups, :web, :web_remote, :autocomplete, :autocomplete_mentors, :autocomplete_mentees, :prepare]

  before_filter :get_query, :only => [:index, :people, :groups, :web, :web_remote, :autocomplete, :autocomplete_mentors, :autocomplete_mentees]

  before_filter :set_num_results_per_page, :only => [:index, :people, :groups, :web, :web_remote]


  FILTER_MENTOR_NONE = 'NULL'


  def index
    if @q.present?
      @people = search_people if session[:search][:authorized_to_search_people]
      @groups = search_groups(@people) if session[:search][:authorized_to_search_groups]
    end
  end

  def people
    if @q.present?
      @people = search_people if session[:search][:authorized_to_search_people]
    end
  end

  def groups
    if @q.present?
      @people = search_people if session[:search][:authorized_to_search_people]
      @groups = search_groups(@people) if session[:search][:authorized_to_search_groups]
    end
  end

  def web
    if @q.present?
      @web = search_web if session[:search][:authorized_to_search_web]
    end
  end

  def web_remote
    if @q.present?
      @web = search_web if session[:search][:authorized_to_search_web]
    end

    respond_to do |format|
      format.js
    end
  end

  def autocomplete
    @all_results_link = params[:all_results_link] == "true" ? true : false if params[:all_results_link].present?
    @ac_actions = params[:actions] == "true" ? true : false if params[:actions].present?
    max_results = params[:max_results].present? ? params[:max_results].to_i : Searching::MAX_NUM_AUTOCOMPLETE_RESULTS

    if logged_in? # necessary because we skip standard login stack for performance gain
      @people = autocomplete_people(max_results) if session[:search][:authorized_to_search_people] && @q.present?
      @discover_contacts = autocomplete_discover_contacts(max_results) #if session[:search][:authorized_to_search_discover_contacts] && @q.present?
    end

    render :layout => false
  end

  def autocomplete_mentors
    @person_id = params[:p]
    @search_for_mentor = true

    if logged_in? # necessary because we skip standard login stack for performance gain
      @people = autocomplete_people if session[:search][:authorized_to_search_people] && @q.present?
    else
      @people = []
    end

    render :layout => false
  end

  def autocomplete_mentees
    @person_id = params[:p]
    @filter_out_mentored = true

    if logged_in? # necessary because we skip standard login stack for performance gain
      @people = autocomplete_people if session[:search][:authorized_to_search_people] && @q.present?
    else
      @people = []
    end

    render :layout => false
  end

  def prepare # call to prepare search via before filter - hopefully to make auto complete faster
    render :nothing => true
  end


  private

  def autocomplete_discover_contacts(max_results = nil)
    @max_num_ac_results ||= max_results || Searching::MAX_NUM_AUTOCOMPLETE_RESULTS

    contacts = DiscoverContact.all(:limit => @max_num_ac_results,
                                   :joins => "LEFT JOIN #{ContactsPerson.table_name} ON #{ContactsPerson.__(:contact_id)} = #{Contact.__(:id)}",
                                   :conditions => ["#{ContactsPerson.__(:person_id)} = ? AND (" +
                                                   "concat(#{Contact.__(:first_name)}, \" \", #{Contact.__(:last_name)}) like ? " +
                                                   "OR #{Contact.__(:first_name)} like ? " +
                                                   "OR #{Contact.__(:last_name)} like ? " +
                                                   "OR #{Contact.__(:email)} like ? " +
                                                   "OR #{Contact.__(:id)} like ? " +
                                                   ")",
                                                   get_person.id, "#{@q}%", "#{@q}%", "#{@q}%", "%#{@q}%", "%#{@q}%"]
                                   )
  end


  def autocomplete_people(max_results = nil)
    @max_num_ac_results ||= max_results || Searching::MAX_NUM_AUTOCOMPLETE_RESULTS


    # I don't know a better way to sanitize the select statement...
    select_str = ActiveRecord::Base.__send__(:sanitize_sql,
       ["#{Person.__(:id)}, #{Person.__(:first_name)}, #{Person.__(:last_name)}, #{Person.__(:email)}, #{ProfilePicture.__(:id)} AS profile_picture_id, #{Timetable.__(:id)} AS timetable_id," +
        "GROUP_CONCAT(DISTINCT #{Campus.__(:short_desc)} SEPARATOR ', ') AS campuses_concat, " +
        "GROUP_CONCAT(#{MinistryRole.__(:id)} SEPARATOR ',') AS staff_role_ids, " +
        "GROUP_CONCAT(DISTINCT #{Ministry.__(:name)} SEPARATOR ', ') AS ministries_concat, " +

        # determine the rank for ordering of results
        "IF(#{Person.__(:first_name)} LIKE ?, #{Searching::SEARCH_RANK[:person][:first_name]}, 0) + " +
        "IF(#{Person.__(:last_name)} LIKE ?, #{Searching::SEARCH_RANK[:person][:last_name]}, 0) + " +
        "IF(GROUP_CONCAT(DISTINCT #{Ministry.__(:name)} SEPARATOR ', ') LIKE ?, #{Searching::SEARCH_RANK[:person][:ministry]}, 0) " +
        " AS rank", "#{@q}%", "#{@q}%", session[:search][:search_ministry_name] ], '')


    if @search_for_mentor || @filter_out_mentored
      if !@person_id
        person = get_person           # i don't really like this, since it looks up Pulse user
        @person_id = person.id        # TODO: replace with something (requires multi-level exception handling, i tried...)
      end
      person = Person.find(@person_id)  # ensures that the profile person is selected, not the Pulse user
    end


    if @filter_out_mentored # i.e. we are searching for a mentee (that is not being mentored)
      if person.person_mentor_id == nil
        person_mentor_id_condition = 'IS NOT NULL'
      else
        person_mentor_id_condition = '<> ' + person.person_mentor_id.to_s
      end

      people = Person.all(:limit => @max_num_ac_results,
                          :joins => "LEFT JOIN #{CampusInvolvement.table_name} ON #{CampusInvolvement.__(:person_id)} = #{Person.__(:person_id)} AND #{CampusInvolvement.__(:end_date)} IS NULL " +
                                    "LEFT JOIN #{Campus.table_name} ON #{Campus.__(:campus_id)} = #{CampusInvolvement.__(:campus_id)} " +
                                    "LEFT JOIN #{ProfilePicture.table_name} ON #{ProfilePicture.__(:person_id)} = #{Person.__(:person_id)} " +
                                    "LEFT JOIN #{MinistryInvolvement.table_name} ON #{MinistryInvolvement.__(:person_id)} = #{Person.__(:person_id)} AND #{MinistryInvolvement.__(:end_date)} IS NULL " +

                                    # need this to find their staff roles to see if they are in fact a staff
                                    "LEFT JOIN #{MinistryRole.table_name} ON #{MinistryRole.__(:id)} = #{MinistryInvolvement.__(:ministry_role_id)} AND #{MinistryRole.__(:type)} = 'StaffRole' " +
                                    "LEFT JOIN #{Timetable.table_name} ON #{Timetable.__(:person_id)} = #{Person.__(:person_id)} " +
                                    # need this to find their ministries to display instead of campuses if they're staff, but skip the P2C and C4C ministries
                                    "LEFT JOIN #{Ministry.table_name} ON #{Ministry.__(:id)} = #{MinistryInvolvement.__(:ministry_id)} AND #{Ministry.__(:id)} > 2 ",

                          :select => select_str,

                          :conditions => ["#{session[:search][:person_search_limit_condition]} " +
                                         "AND #{Person.__(:person_mentor_id)} IS #{FILTER_MENTOR_NONE} " +
                                         "AND #{Person.__(:person_id)} #{person_mentor_id_condition} " +
                                         "AND #{Person.__(:person_id)} <> #{@person_id} AND (" +
                                         "concat(#{_(:first_name, :person)}, \" \", #{_(:last_name, :person)}) like ? " +
                                         "or #{_(:first_name, :person)} like ? " +
                                         "or #{_(:last_name, :person)} like ? " +
                                         "or #{_(:email, :person)} like ? " +
                                         "or #{Person.table_name}.#{_(:id, :person)} like ? " +
                                         ")",
                                         "#{@q}%", "#{@q}%", "#{@q}%", "%#{@q}%", "%#{@q}%"],

                          :order => 'rank DESC',

                          :group => "#{Person.__(:id)}")

   elsif @search_for_mentor
     people = Person.all(:limit => @max_num_ac_results,
                         :joins => "LEFT JOIN #{CampusInvolvement.table_name} ON #{CampusInvolvement.__(:person_id)} = #{Person.__(:person_id)} AND #{CampusInvolvement.__(:end_date)} IS NULL " +
                                   "LEFT JOIN #{Campus.table_name} ON #{Campus.__(:campus_id)} = #{CampusInvolvement.__(:campus_id)} " +
                                   "LEFT JOIN #{ProfilePicture.table_name} ON #{ProfilePicture.__(:person_id)} = #{Person.__(:person_id)} " +
                                   "LEFT JOIN #{MinistryInvolvement.table_name} ON #{MinistryInvolvement.__(:person_id)} = #{Person.__(:person_id)} AND #{MinistryInvolvement.__(:end_date)} IS NULL " +

                                   # need this to find their staff roles to see if they are in fact a staff
                                   "LEFT JOIN #{MinistryRole.table_name} ON #{MinistryRole.__(:id)} = #{MinistryInvolvement.__(:ministry_role_id)} AND #{MinistryRole.__(:type)} = 'StaffRole' " +
                                   "LEFT JOIN #{Timetable.table_name} ON #{Timetable.__(:person_id)} = #{Person.__(:person_id)} " +
                                   # need this to find their ministries to display instead of campuses if they're staff, but skip the P2C and C4C ministries
                                   "LEFT JOIN #{Ministry.table_name} ON #{Ministry.__(:id)} = #{MinistryInvolvement.__(:ministry_id)} AND #{Ministry.__(:id)} > 2 ",

                         :select => select_str,

                         :conditions => ["#{session[:search][:person_search_limit_condition]} " +
                                         "AND (#{Person.__(:person_mentor_id)} IS #{FILTER_MENTOR_NONE} " +
                                         "OR #{Person.__(:person_mentor_id)} <> #{@person_id}) " +
                                         "AND #{Person.__(:person_id)} <> #{@person_id} AND (" +
                                         "concat(#{_(:first_name, :person)}, \" \", #{_(:last_name, :person)}) like ? " +
                                         "or #{_(:first_name, :person)} like ? " +
                                         "or #{_(:last_name, :person)} like ? " +
                                         "or #{_(:email, :person)} like ? " +
                                         "or #{Person.table_name}.#{_(:id, :person)} like ? " +
                                         ")",
                                         "#{@q}%", "#{@q}%", "#{@q}%", "%#{@q}%", "%#{@q}%"],

                         :order => 'rank DESC',

                         :group => "#{Person.__(:id)}")

    else
       people = Person.all(:limit => @max_num_ac_results,
                           :joins => "LEFT JOIN #{CampusInvolvement.table_name} ON #{CampusInvolvement.__(:person_id)} = #{Person.__(:person_id)} AND #{CampusInvolvement.__(:end_date)} IS NULL " +
                                     "LEFT JOIN #{Campus.table_name} ON #{Campus.__(:campus_id)} = #{CampusInvolvement.__(:campus_id)} " +
                                     "LEFT JOIN #{ProfilePicture.table_name} ON #{ProfilePicture.__(:person_id)} = #{Person.__(:person_id)} " +
                                     "LEFT JOIN #{MinistryInvolvement.table_name} ON #{MinistryInvolvement.__(:person_id)} = #{Person.__(:person_id)} AND #{MinistryInvolvement.__(:end_date)} IS NULL " +

                                     # need this to find their staff roles to see if they are in fact a staff
                                     "LEFT JOIN #{MinistryRole.table_name} ON #{MinistryRole.__(:id)} = #{MinistryInvolvement.__(:ministry_role_id)} AND #{MinistryRole.__(:type)} = 'StaffRole' " +
                                     "LEFT JOIN #{Timetable.table_name} ON #{Timetable.__(:person_id)} = #{Person.__(:person_id)} " +
                                     # need this to find their ministries to display instead of campuses if they're staff, but skip the P2C and C4C ministries
                                     "LEFT JOIN #{Ministry.table_name} ON #{Ministry.__(:id)} = #{MinistryInvolvement.__(:ministry_id)} AND #{Ministry.__(:id)} > 2 ",

                           :select => select_str,

                           :conditions => ["#{session[:search][:person_search_limit_condition]} AND (" +
                                           "concat(#{_(:first_name, :person)}, \" \", #{_(:last_name, :person)}) like ? " +
                                           "or #{_(:first_name, :person)} like ? " +
                                           "or #{_(:last_name, :person)} like ? " +
                                           "or #{_(:email, :person)} like ? " +
                                           "or #{Person.table_name}.#{_(:id, :person)} like ? " +
                                           ")",
                                           "#{@q}%", "#{@q}%", "#{@q}%", "%#{@q}%", "%#{@q}%"],

                           :order => 'rank DESC',

                           :group => "#{Person.__(:id)}")
    end

    people
  end

end
