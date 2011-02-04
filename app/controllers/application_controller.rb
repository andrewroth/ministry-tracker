require 'cgi'
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include ActiveRecord::ConnectionAdapters::Quoting

  ############################################################
  # ERROR HANDLING et Foo
  include ExceptionNotification::ExceptionNotifiable
  #Comment out the line below if you want to see the normal rails errors in normal development.
  #alias :rescue_action_locally :rescue_action_in_public if Rails.env == 'development'
  #self.error_layout = 'errors'
  self.exception_notifiable_verbose = true #SEN uses logger.info, so won't be verbose in production
  self.exception_notifiable_pass_through = :hoptoad # requires the standard hoptoad gem to be installed, and setup normally
  #self.exception_notifiable_silent_exceptions = [ ActionController::RoutingError ]
  #specific errors can be handled by something else:
  #rescue_from 'Acl9::AccessDenied', :with => :access_denied
  # END ERROR HANDLING
  ############################################################

  
  if Cmt::CONFIG[:facebook_connectivity_enabled]
    before_filter :set_facebook_session
    helper_method :facebook_session
  end

  # include ExceptionNotifiable
  # self.error_layout = false
  
  self.allow_forgery_protection = false

  # Pick a unique cookie name to distinguish our session data from others'
  helper_method :format_date, :_, :receipt, :is_ministry_leader, :is_ministry_leader_somewhere, :team_admin, 
                :get_ministry, :current_user, :is_ministry_admin, :authorized?, :is_group_leader, :can_manage, 
		:get_people_responsible_for
		
  case
  when !Cmt::CONFIG[:gcx_direct_logins] && Cmt::CONFIG[:gcx_greenscreen_directly]
    #before_filter CASClient::Frameworks::Rails::Filter
    before_filter :cas_filter
  when Cmt::CONFIG[:gcx_direct_logins] || Cmt::CONFIG[:gcx_greenscreen_from_link]
    #before_filter CASClient::Frameworks::Rails::GatewayFilter 
    before_filter :cas_gateway_filter
  end unless Rails.env.test?

   # before_filter :fake_login

  before_filter :login_required, :get_person, :force_required_data, :get_ministry, :set_locale#, :get_bar
  before_filter :authorization_filter
  
  helper :all

  protected

    def cas_filter
      return if logged_in?
      CASClient::Frameworks::Rails::Filter.filter(self)
    end

    def cas_gateway_filter
      return if logged_in?
      CASClient::Frameworks::Rails::GatewayFilter.filter(self)
    end

    def fake_login
      self.current_user = User.find(Person.find(50195).user_id)
    end
    # =============================================================================
    # = See vendor/plugins/mappings/load_mappings.rb                              =
    # =============================================================================
    def _(column, table)
      ActiveRecord::Base._(column, table)
    end
    
    def current_ministry; @ministry; end
    helper_method :current_ministry
    
    def possible_roles
      unless @possible_roles
        @possible_roles = get_ministry.ministry_roles.find(:all, :conditions => "#{_(:type, :ministry_roles)} <> 'OtherRole'")
        # remove all 'Other' roles for now
        # @possible_roles.reject! { |r| r.class == OtherRole }
        # # if staff, allow all student roles
        # @possible_roles += StudentRole.all
        # @possible_roles.uniq!
      end
      @possible_roles
    end
    helper_method :possible_roles
    
    def format_date(value, format = :default)
      return '' if value.blank?
      date = value.is_a?(Date) ? value : Date.parse(value.to_s)
      date.to_formatted_s(format)
    end

    def get_my_ministry_involvement(ministry = get_ministry)
      get_ministry_involvement(ministry, @me)
    end

    def get_my_role(ministry = get_ministry)
      get_my_ministry_involvement(ministry).try(:ministry_role)
    end

    def get_ministry_involvement(ministry, person = @person, force_only_this_ministry = false)
      # TODO: can do this in one query without using ancestor_ids now
      @ministry_involvement = person.ministry_involvements.find(:first, :conditions => ["#{MinistryInvolvement.table_name + '.' + _(:ministry_id, :ministry_involvement)} IN (?) AND end_date is NULL", force_only_this_ministry ? ministry.id : ministry.ancestor_ids], :joins => :ministry_role, :order => _(:position, :ministry_role))
    end
    
    def setup_ministries
      @ministry_involvements = @person.ministry_involvements.find(:all, 
                                                                  :order => Ministry.table_name + '.' + _(:name, 'ministry'),
                                                                  :include => [:ministry])
    end
    
    def get_countries
      @countries = CmtGeo.all_countries
    end

    def is_group_leader(group, person = nil)
      person ||= (@me || get_person)
      return group.leaders.include?(person) || authorized?(:edit, :groups)
    end
    
    def is_ministry_leader( ministry = nil, person = nil)
      return true if is_ministry_admin(ministry, person)
      ministry ||= @ministry || get_ministry
      person ||= (@me || get_person)
      involvement = get_ministry_involvement(ministry, person)
      return (involvement && involvement.try(:ministry_role).is_a?(StaffRole)) || ministry.staff.include?(person) || (involvement && involvement.admin?)
    end
    
    def is_ministry_leader_somewhere(person = nil)
      person ||= (@me || get_person)
      return false unless person
      @is_ministry_leader ||= {}
      @is_ministry_leader[person.id] ||= !MinistryInvolvement.find(:first, :conditions => 
         ["#{_(:person_id, :ministry_involvement)} = ? AND (#{_(:ministry_role_id, :ministry_involvement)} IN (?) OR admin = 1) AND #{_(:end_date, :ministry_involvement)} is null", 
         person.id, get_ministry.root.leader_role_ids]).nil?
    end
    
    def is_staff_somewhere(person = nil)
      person ||= (@me || get_person)
      return false unless person
      @is_staff_somewhere ||= {}
      @is_staff_somewhere[person.id] ||= person.is_staff_somewhere?
    end
    helper_method :is_staff_somewhere
 
    def can_manage
      unless session[:can_manage]
        session[:can_manage] = authorized?(:new, :ministries) || authorized?(:edit, :ministries) ||
                               authorized?(:new, :involvement_questions) || authorized?(:new, :training_questions) ||
                               authorized?(:new, :people) || authorized?(:new, :groups) ||
                    		       authorized?(:new, :views) || authorized?(:new, :custom_attributes) ||
                    		       authorized?(:new, :group_types) || authorized?(:new, :dorms)
      end
      session[:can_manage]
    end
    
    def is_involved_somewhere(person = nil)
      person ||= (@me || get_person)
      return MinistryInvolvement.find(:first, :conditions => ["#{_(:person_id, :ministry_involvement)} = ? AND #{_(:ministry_role_id, :ministry_involvement)} IN (?)", person.id, get_ministry.involved_student_role_ids])
    end
    
    def is_ministry_admin(ministry = nil, person = nil)
      session[:admins] ||= {}
      ministry ||= current_ministry
      return false unless ministry
      session[:admins][ministry.id] ||= {}
      person ||= (@me || get_person)
      unless session[:admins][ministry.id][person.id]
        session[:admins][ministry.id][person.id] = person.admin?(ministry)
      end
      return session[:admins][ministry.id][person.id]
    end
    alias_method :is_admin?, :is_ministry_admin
    helper_method :is_admin?
    
    # These actions all have custom code to check that for the current user
    # being the owner of such groups, and then returning true in that case
    AUTHORIZE_FOR_OWNER_ACTIONS = {
      :people => [:edit, :update, :show, :import_gcx_profile, :getcampuses,
                  :get_campus_states, :set_current_address_states,
                  :set_permanent_address_states, :new, :remove_mentor, :remove_mentee],
      :profile_pictures => [:new, :edit, :destroy],
      :timetables => [:show, :edit, :update],
      :groups => [:show, :edit, :update, :destroy, :compare_timetables, :set_start_time, :set_end_time],
      :group_involvements => [:accept_request, :decline_request, :transfer, :change_level, :destroy, :create],
      :campus_involvements => [:new, :edit, :index],
      :ministry_involvements => [:new, :edit, :index]
    }
    
    def authorized?(action = nil, controller = nil, ministry = nil)
      return true if is_ministry_admin
      ministry ||= get_ministry
      return false unless ministry

      unless @user_permissions && @user_permissions[ministry]
        @user_permissions ||= {}
        @user_permissions[ministry] ||= {}
        # Find the highest level of access they have at or above the level of the current ministry
        if session[:"ministry_#{ministry.id}_role_id"].nil?
          mi = @my.ministry_involvements.find(:first, :conditions => ["#{MinistryInvolvement.table_name + '.' + _(:ministry_id, :ministry_involvement)} IN (?) AND end_date is NULL", ministry.ancestor_ids], :joins => :ministry_role, :order => _(:position, :ministry_role))
          session[:"ministry_#{ministry.id}_role_id"] = mi ? mi.ministry_role_id : false
        end
        if session[:"ministry_#{ministry.id}_role_id"]
          role = MinistryRole.find(session[:"ministry_#{ministry.id}_role_id"])
          role.permissions.each do |perm|
            @user_permissions[ministry][perm.controller] ||= []
            @user_permissions[ministry][perm.controller] << perm.action
          end
        end
      end
      
      original_action = action || action_name
      action ||= ['create','destroy'].include?(action_name.to_s) ? 'new' : action_name.to_s
      action = action == 'update' ? 'edit' : action
      controller ||= controller_name.to_s

      # Make sure we're always using strings      
      action = action.to_s
      controller = controller.to_s
      original_action = original_action.to_s
      
      # Owner Action Checking
      # NOTE: These need to be done after action & controller are set
      if AUTHORIZE_FOR_OWNER_ACTIONS[controller.to_sym] &&
        AUTHORIZE_FOR_OWNER_ACTIONS[controller.to_sym].include?(action.to_sym)
        case controller.to_sym
        when :people
          if action == 'edit' && @me.is_leading_mentor_priority_group_with?(@person || Person.find(params[:id]))
            return true
          end
          
          ## see '_mentor_search_box' partial for 'add_mentor' & @person == @me logic (vs 'add_mentor_other')
          
          # also return true if person is destroying self-involvements (don't return true for creation of new profile)
          if params[:id] && params[:id] == @my.id.to_s && original_action != "new" && original_action != "create"
            return true
          end
          
        when :profile_pictures, :timetables
          if (params[:person_id] && params[:person_id] == @my.id.to_s) || (@person == @me)
            return true
          elsif controller.to_sym == :timetables && params[:person_id] &&
            @me.is_leading_group_with?(Person.find(params[:person_id]))
            return true
          elsif controller.to_sym == :timetables && @person && @me.is_leading_group_with?(@person)
            return true
          end
        when :groups
          if params[:id] || @group
            @group ||= Group.find(params[:id])
            if action == 'show' && @group.is_member(@me)
              return true
            elsif @group.is_leader(@me) || @group.is_co_leader(@me)
              return true
            end
          end
        when :group_involvements
          if params[:id] || @gi
            @gi ||= GroupInvolvement.find_by_id(params[:id])
            @group ||= @gi.try(:group) || (params[:group_id] && Group.find(params[:group_id]))
            if @group && (@group.is_leader(@me) || @group.is_co_leader(@me))
              return true
            end
          end
        when :campus_involvements, :ministry_involvements
          if params[:person_id] == @my.id.to_s 
            return true
          end   
          if @person == @me
            return true
          end
          
        end # case
      end # if

      # First see if this is restricted in the permissions table
      permission = Permission.find(:first, :conditions => {_(:action, :permission) => action.to_s, _(:controller, :permission) => controller.to_s})
      if permission
        return @user_permissions[ministry][controller] && @user_permissions[ministry][controller].include?(action)
      end
      
      return Cmt::CONFIG[:permissions_granted_by_default]
    end

    def ministry_involvement_granting_authorization(action = nil, controller = nil, ministry = nil)
      if is_ministry_admin
        mi = ::MinistryInvolvement.build_highest_ministry_involvement_possible(@me)
      else
        mi = @me.highest_ministry_involvement_with_particular_role(role_granting_authorization(action, controller, ministry))
      end
      mi
    end

    def role_granting_authorization(action = nil, controller = nil, ministry = nil)
      if authorized?(action, controller, ministry)

        ministry ||= get_ministry
        return false unless ministry

        action ||= ['create','destroy'].include?(action_name.to_s) ? 'new' : action_name.to_s
        action = action == 'update' ? 'edit' : action
        controller ||= controller_name.to_s

        # Make sure we're always using strings
        action = action.to_s
        controller = controller.to_s


        my_role_ids = @my.ministry_involvements.collect{ |mi| mi.ministry_role_id }

        mrps = ::MinistryRolePermission.all(:joins => :permission,
          :conditions => ["#{::Permission.table_name}.#{_(:action, :permission)} = ? AND #{::Permission.table_name}.#{_(:controller, :permission)} = ? AND ministry_role_id IN (?)", action.to_s, controller.to_s, my_role_ids ] )

        ::MinistryRole.all(:first, :conditions => ["id IN (?)", mrps.collect {|mrp| mrp.ministry_role_id } ], :order => "#{::MinistryRole.table_name}.position ASC").first

      else
        nil
      end
    end
    
#    def authorization_allowed_for_owner
#      unless self.respond_to?(:is_owner) && is_owner
#        authorization_filter
#      end
#    end    
    
    def authorization_filter
      unless controller_name == 'dashboard' || authorized?
        respond_to do |wants|
          wants.html { redirect_to '/' }
          wants.js   { render :nothing => true}
        end
        return false
      end
    end
    
    def team_admin
      @team_admin ||= true if get_ministry.staff.include?(@person)
    end
    
    def get_group(group_id = nil)
      group_id ||= params[:id]
      @group = Group.find(params[:id], :include => {:group_involvements => {:person => :current_address}}, 
                                       :order => Person.table_name + '.' + _(:last_name, :person) + ',' + 
                                       Person.table_name + '.' + _(:first_name, :person))
    end

    # ===========
    # = Filters =
    # ===========
    def set_locale
      locales = ['en', 'en-AU']
      begin
        # Try to auto-detect it
        if request.headers['Accept-Language']
          browser_language = request.headers['Accept-Language'].split(',')[0] 
          browser_language = browser_language.split('-')[0] + '-' + browser_language.split('-')[1].upcase
          session[:locale] = browser_language
        end
        session[:locale] = params[:locale] if params[:locale]
        session[:locale] = 'en-AU' if session[:locale] == 'en-GB'
        I18n.locale = locales.include?(session[:locale]) ? session[:locale] : I18n.default_locale
      rescue
        I18n.locale = I18n.default_locale
      end
    end
    
    def ministry_admin_filter
      if params[:ministry_id]
        ministry = Ministry.find(params[:ministry_id]) unless @ministry && @ministry.id == params[:ministry_id]
      else
        ministry = get_ministry.root
      end
      unless is_ministry_admin(ministry, @me)
        render :nothing => true 
        return false
       end
    end
    
    def developer_filter
      return current_user.developer?
    end
    
    def ministry_leader_filter
      unless is_ministry_leader
        render :nothing => true 
        return false
       end
    end
    
    def get_person
      @person = params[:person_id] ? Person.find(params[:person_id]) : nil
      # Initialize the logged in person
      @me = @my = current_user.person unless current_user == :false
      
      # if we didn't get a person in the params, set it now
      @person ||= @me
      if @person.nil?
        return false 
      end
      @person
    end
    
    def get_ministry
      @person ||= get_person
      raise "no person" unless @person
      unless @ministry
        @ministry = Ministry.find :first, :conditions => { :id => session[:ministry_id] } if session[:ministry_id].present?
        # security feature: restrict students
        if @ministry && !is_staff_somewhere
          @ministry = @person.ministries.find_by_id session[:ministry_id]
        end
        @ministry ||= @person.most_nested_ministry

        # If we didn't get a ministry out of that, check for a ministry through campus
        @ministry ||= @person.campus_involvements.first.ministry unless @person.campus_involvements.empty? 

        # If we still don't have a ministry, this person hasn't been assigned a campus.
        # Looks like we have to give them some dummy information. BUG 1857 
        #@ministry ||= associate_person_with_default_ministry(@person) if @person.ministries.empty?
        return unless @ministry # at this point we can abort, since it should force them to choose a campus

        # if we currently have the top level ministry, great. If not, get it.
        if @ministry.root?
          @root_ministry = @ministry
        else
          @root_ministry = session[:root_ministry_ids] ? Ministry.find(session[:root_ministry_id]) : @ministry.root
        end
        session[:ministry_id] ||= @ministry.id if @ministry
        session[:root_ministry_id] ||= @root_ministry.id if @root_ministry
      end
      @ministry
    end
    
      
    def setup_involvement_vars
      @projects = @person.summer_projects.find(:all, :conditions => "#{_(:status, :summer_project_application)} IN ('accepted_as_participant','accepted_as_intern')")
      @prefs = []
      @person.summer_project_applications.each do |app| 
        @prefs << [app.preference1, app.preference2, app.preference3, app.preference4, app.preference5].compact 
      end
      @prefs = @prefs.flatten - @projects
      @conferences = @person.conferences.uniq 
      @stints = @person.stint_locations
    end
    
    def adjust_format_for_facebook
      request.format = :facebook if iphone_request?
    end
    
    def default_country
      @default_country ||= (Country.find(:first, :conditions => { _(:country, :country) => Cmt::CONFIG[:default_country] }) || Country.new)
    end

    def get_person_campuses
      @person_campuses = @my.working_campuses(get_ministry_involvement(get_ministry))
    end

    def get_person_current_campuses
      @person_current_campuses = @my.campus_list(get_ministry_involvement(get_ministry), get_ministry)
    end

    def force_required_data
      return false unless force_email_set
      return false unless force_campus_set
    end
    
    def force_email_set
      if current_user && (current_user.username.nil? || current_user.username == current_user.facebook_hash)
        redirect_to prompt_for_email_users_path
        return false
      end
      true
    end
    
    def force_campus_set
      return false unless @my
      if !is_staff_somewhere && @my.campus_involvements.empty?
        redirect_to set_initial_campus_person_url(@my.id)
        return false
      elsif is_staff_somewhere && @my.ministry_involvements.empty?
        redirect_to set_initial_ministry_person_url(@my.id)
        return false
      end
      true
    end

    def base_url
      if request.port != 80
        request.protocol + request.host_with_port
      else
        request.protocol + request.host
      end
    end

    def set_notices
      @dismissed_notice_ids = [0] + @my.dismissed_notices.collect(&:notice_id)
      @notices = Notice.find(:all, :conditions => [ 
        "#{Notice._(:live)} is true AND #{Notice._(:id)} NOT IN (?)", @dismissed_notice_ids
      ])
    end

    def self.skip_standard_login_stack(additional_params = {})
      skip_before_filter(:login_required, :get_person, :get_ministry, :authorization_filter, :force_required_data, :set_initial_campus, :cas_filter, :cas_gateway_filter, additional_params)
    end

    def redirect_unless_is_active_hrdb_staff
      unless @me.cim_hrdb_staff.try(:boolean_is_active)
        flash[:notice] = "<img src='images/silk/exclamation.png' style='float: left; margin-right: 7px;'> Your account has not been set up properly by the Operations team. Please contact <b>helpdesk@c4c.ca</b> so that we can correct this. Thanks."
        redirect_to :action => "index", :controller => "stats"
        return false
      end
      return true
    end

    # code is received from facebook on callback after a user authorizes the app using redirects, the code allows us to get the oauth token
    def load_my_facebook_graph_into_session_from_code(code)
      @oauth ||= Koala::Facebook::OAuth.new
      load_my_facebook_graph_into_session_from_oauth_token(@oauth.get_access_token(code))
    end

    def load_my_facebook_graph_into_session_from_oauth_token(oauth_token)
      @graph = Koala::Facebook::GraphAPI.new(oauth_token)
      session[:facebook_person] = @graph.get_object("me")
    end

end
