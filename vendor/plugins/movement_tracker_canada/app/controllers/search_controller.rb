class SearchController < ApplicationController
  unloadable

  skip_standard_login_stack :only => [:autocomplete, :autocomplete_people, :search_people]

  before_filter :setup_session_for_search, :only => [:index, :autocomplete]


  MAX_NUM_AUTOCOMPLETE_RESULTS = 5
  DEFAULT_NUM_SEARCH_RESULTS = 10


  def index
    @q = params["q"]

    if session[:authorized_to_search_people]
      @people = search_people if @q.present?
    end
  end


  def autocomplete
    @q = params["q"]

    if session[:authorized_to_search_people]
      @people = autocomplete_people if @q.present?
    end

    render :layout => false
  end


  private

  def search_people

    params[:per_page] ||= DEFAULT_NUM_SEARCH_RESULTS

    # I don't know a better way to sanitize the select statement...
    select_str = ActiveRecord::Base.__send__(:sanitize_sql,
       ["#{Person.__(:id)}, #{Person.__(:first_name)}, #{Person.__(:last_name)}, #{Person.__(:email)}, #{Person.__(:cell_phone)}, #{Person.__(:person_local_phone)}, #{Person.__(:person_phone)}, " +
        "#{ProfilePicture.__(:filename)}, #{Timetable.__(:id)} AS timetable_id, #{SchoolYear.__(:year_desc)}, " +
        "GROUP_CONCAT(DISTINCT #{Campus.__(:short_desc)} SEPARATOR ', ') AS campuses_concat, " +
        "GROUP_CONCAT(#{MinistryRole.__(:id)} SEPARATOR ',') AS staff_role_ids, " +
        "GROUP_CONCAT(DISTINCT #{Ministry.__(:name)} SEPARATOR ', ') AS ministries_concat, " +

        # determine the rank for ordering of results
        "IF(#{Person.__(:first_name)} LIKE ?,2,0) + IF(#{Person.__(:last_name)} LIKE ?,1,0)" +
        " AS rank", "#{@q}%", "#{@q}%"], '')

    Person.paginate(:page => params[:page],
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

                    :conditions => ["#{session[:search_limit_condition]} AND (" +
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

  def autocomplete_people

    @max_num_ac_results = MAX_NUM_AUTOCOMPLETE_RESULTS

    # I don't know a better way to sanitize the select statement...
    select_str = ActiveRecord::Base.__send__(:sanitize_sql,
       ["#{Person.__(:id)}, #{Person.__(:first_name)}, #{Person.__(:last_name)}, #{Person.__(:email)}, #{ProfilePicture.__(:filename)}, " +
        "GROUP_CONCAT(DISTINCT #{Campus.__(:short_desc)} SEPARATOR ', ') AS campuses_concat, " +
        "GROUP_CONCAT(#{MinistryRole.__(:id)} SEPARATOR ',') AS staff_role_ids, " +
        "GROUP_CONCAT(DISTINCT #{Ministry.__(:name)} SEPARATOR ', ') AS ministries_concat, " +

        # determine the rank for ordering of results
        "IF(#{Person.__(:first_name)} LIKE ?,2,0) + IF(#{Person.__(:last_name)} LIKE ?,1,0)" +
        " AS rank", "#{@q}%", "#{@q}%"], '')

    Person.all(:limit => MAX_NUM_AUTOCOMPLETE_RESULTS,
               :joins => "LEFT JOIN #{CampusInvolvement.table_name} ON #{CampusInvolvement.__(:person_id)} = #{Person.__(:person_id)} AND #{CampusInvolvement.__(:end_date)} IS NULL " +
                         "LEFT JOIN #{Campus.table_name} ON #{Campus.__(:campus_id)} = #{CampusInvolvement.__(:campus_id)} " +
                         "LEFT JOIN #{ProfilePicture.table_name} ON #{ProfilePicture.__(:person_id)} = #{Person.__(:person_id)} " +
                         "LEFT JOIN #{MinistryInvolvement.table_name} ON #{MinistryInvolvement.__(:person_id)} = #{Person.__(:person_id)} AND #{MinistryInvolvement.__(:end_date)} IS NULL " +

                         # need this to find their staff roles to see if they are in fact a staff
                         "LEFT JOIN #{MinistryRole.table_name} ON #{MinistryRole.__(:id)} = #{MinistryInvolvement.__(:ministry_role_id)} AND #{MinistryRole.__(:type)} = 'StaffRole' " +

                         # need this to find their ministries to display instead of campuses if they're staff, but skip the P2C and C4C ministries
                         "LEFT JOIN #{Ministry.table_name} ON #{Ministry.__(:id)} = #{MinistryInvolvement.__(:ministry_id)} AND #{Ministry.__(:id)} > 2 ",

               :select => select_str,

               :conditions => ["#{session[:search_limit_condition]} AND (" +
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


  def get_involvement_limit_condition
    @person ||= get_person
    @ministry ||= get_ministry

    @ministries = @person.ministries.collect {|ministry| ministry.self_plus_descendants }.flatten.uniq
    @ministry_search_ids = @ministries.collect {|ministry| ministry.id}
    @ministry_search_ids = [0] if (@ministry_search_ids.blank? || @ministry_search_ids.empty?)

    @campuses ||= @my.campus_list(get_ministry_involvement(@ministry), @ministry)
    @campus_search_ids ||= @campuses.collect {|c| c.id}
    @campus_search_ids = [0] if (@campus_search_ids.blank? || @campus_search_ids.empty?)

    # don't return people who have no involvements and don't return people who I don't have access to see based on my involvements
    if is_staff_somewhere
      involvement_limit_condition = "(#{MinistryInvolvement.__(:id)} IS NOT NULL or #{CampusInvolvement.__(:id)} IS NOT NULL) AND " +
        "(#{MinistryInvolvement.__(:ministry_id)} in (#{quote_string(@ministry_search_ids.join(','))}) OR #{CampusInvolvement.__(:campus_id)} in (#{quote_string(@campus_search_ids.join(','))})) "
    else
      involvement_limit_condition = "(#{MinistryInvolvement.__(:id)} IS NOT NULL or #{CampusInvolvement.__(:id)} IS NOT NULL) AND " +
        "(#{MinistryInvolvement.__(:ministry_id)} in (#{quote_string(@ministry_search_ids.join(','))}) AND #{CampusInvolvement.__(:campus_id)} in (#{quote_string(@campus_search_ids.join(','))})) "
    end

    involvement_limit_condition 
  end


  def setup_session_for_search
    session[:search_limit_condition] ||= get_involvement_limit_condition

    session[:authorized_to_search_people] ||= (authorized?(:return_people, :search) && authorized?(:show, :people) && authorized?(:search, :people))
  end

end
