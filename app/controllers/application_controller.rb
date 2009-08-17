require 'cgi'
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include ActiveRecord::ConnectionAdapters::Quoting
  include HoptoadNotifier::Catcher
  
  self.allow_forgery_protection = false

  # Pick a unique cookie name to distinguish our session data from others'
  helper_method :format_date, :_, :receipt, :is_ministry_leader, :is_ministry_leader_somewhere, :team_admin, 
                :get_ministry, :current_user, :is_ministry_admin, :authorized?, :is_group_leader, :can_manage, 
		:get_people_responsible_for
  #before_filter CASClient::Frameworks::Rails::GatewayFilter unless Rails.env.test?
  #    use this line for production  
  before_filter :login_required, :get_person, :get_ministry, :set_locale#, :get_bar
#  before_filter :fake_login, :login_required, :get_person, :get_ministry, :set_locale#, :get_bar
  before_filter :authorization_filter
  
  helper :all

  #protected
    def fake_login
      self.current_user = User.find(Person.find(50195).user_id)
    end
    # =============================================================================
    # = See vendor/plugins/mappings/load_mappings.rb                              =
    # =============================================================================
    def _(column, table)
      ActiveRecord::Base._(column, table)
    end
    
    def format_date(value, format = :default)
      return '' if value.blank?
      date = value.is_a?(Date) ? value : Date.parse(value.to_s)
      date.to_formatted_s(format)
    end

    def get_ministry_involvement(ministry)
      @ministry_involvement = @person.ministry_involvements.find_by_ministry_id(ministry.id, :include => :ministry)
    end
    
    def setup_ministries
      @ministry_involvements = @person.ministry_involvements.find(:all, 
                                                                  :order => Ministry.table_name + '.' + _(:name, 'ministry'),
                                                                  :include => [:ministry])
    end
    
    def get_countries
        #@countries = Country.find(:all, :order => _(:country, 'country')).reject{|c| c.is_closed && c.is_close != 0}
      @countries = CmtGeo.all_countries
    end

    def is_group_leader(group, person = nil)
      person ||= (@me || get_person)
      return group.leaders.include?(person) || authorized?(:edit, :groups)
    end
    
    def is_ministry_leader( ministry = nil, person = nil)
      ministry ||= @ministry || get_ministry
      person ||= (@me || get_person)
      involvement = person.ministry_involvements.detect {|mi| mi.ministry_id == ministry.id}
      return ministry.staff.include?(person) || (involvement && involvement.admin?)
    end
    
    def is_ministry_leader_somewhere(person = nil)
      person ||= (@me || get_person)
      return false unless person
      @is_ministry_leader ||= {}
      @is_ministry_leader[person.id] ||= !MinistryInvolvement.find(:first, :conditions => 
                                          ["#{_(:person_id, :ministry_involvement)} = ? AND (#{_(:ministry_role_id, :ministry_involvement)} IN (?) OR admin = 1)", 
                                            @my.id, get_ministry.root.leader_roles_ids]).nil?
    end
    
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
      ministry ||= get_ministry
      session[:admins][ministry.id] ||= {}
      person ||= (@me || get_person)
      unless session[:admins][ministry.id][person.id]
        session[:admins][ministry.id][person.id] = person.admin?(ministry)
      end
      return session[:admins][ministry.id][person.id]
    end
    
    # you can map controllers and actions to another controller/action's permissions in this format:
    #
    # PERMISSION_MAPPINGS = {
    #   'group_types' => {
    #     'edit' => { :controller => 'another', :action => 'another' },
    #     'edit' => { :action => 'samecontroller_differentaction' }
    #   }
    # }
    #
    # and then access them with 
    #
    # PERMISSION_MAPPINGS['group_types']['edit'][:action]
    # PERMISSION_MAPPINGS['group_types']['edit'][:controller]
    #
    # If no controller mapping is given, it assumes the same controller
    #
    PERMISSION_MAPPINGS = {
#      '*init' => {
#        'create' => { :action => 'new' },
#        'destroy' => { :action => 'new' }
#      },
#      '*' => {
#        'update' => { :action => 'edit' }
#      },
      'groups' => {
        #'compare_timetables' => { :controller => nil, :action => '' },
        #'join' => { :controller => nil, :action => '' },
        #'index' => { :action => 'new' },
        'create' => { :action => 'new' },
        #'new' => { :action => 'new' },
        'edit' => { :action => 'new' },
        #'find_times' => { :controller => nil, :action => '' },
        #'show' => { :controller => nil, :action => '' },
        #'update' => { :controller => nil, :action => '' },
        #'destroy' => { :controller => nil, :action => '' }
      }#,
#      'group_types' => {
#        'index' => { :controller => '', :action => '' },
#        'create' => { :controller => '', :action => '' },
#        'new' => { :controller => '', :action => '' },
#        'edit' => { :controller => '', :action => '' },
#        'show' => { :controller => '', :action => '' },
#        'update' => { :controller => '', :action => '' },
#        'destroy' => { :controller => '', :action => '' }
#      },
#      'group_involvements' => {
#        'accept_request' => { :controller => '', :action => '' },
#        'decline_request' => { :controller => '', :action => '' },
#        'index' => { :controller => '', :action => '' },
#        'create' => { :controller => '', :action => '' },
#        'new' => { :controller => '', :action => '' },
#        'edit' => { :controller => '', :action => '' },
#        'show' => { :controller => '', :action => '' },
#        'update' => { :controller => '', :action => '' },
#        'destroy' => { :controller => '', :action => '' }
#      }
    }
    
    # Hash for Owner Action Checks
    AUTHORIZE_FOR_OWNER_ACTIONS = {
      :people => [:edit, :update, :show, :import_gcx_profile, :getcampuses,
                  :get_campus_states, :set_current_address_states,
                  :set_permanent_address_states],
      :profile_pictures => [:create, :update, :destroy],
      :timetables => [:show, :edit, :update],
      :groups => [:edit, :update, :destroy, :compare_timetables, :set_start_time]
    }
    
    def authorized?(action = nil, controller = nil, ministry = nil)
      return true if is_ministry_admin
      
      ministry ||= get_ministry
      unless @user_permissions && @user_permissions[ministry]
        @user_permissions ||= {}
        @user_permissions[ministry] ||= {}
        # Find the highest level of access they have at or above the level of the current ministry
        if session[:ministry_role_id].nil?
          mi = @my.ministry_involvements.find(:first, :conditions => ["#{MinistryInvolvement.table_name + '.' + _(:ministry_id, :ministry_involvement)} IN (?)", ministry.ancestor_ids], :joins => :ministry_role, :order => _(:position, :ministry_role))
          session[:ministry_role_id] = mi ? mi.ministry_role_id : false
        end
        if session[:ministry_role_id]
          role = MinistryRole.find(session[:ministry_role_id])
          role.permissions.each do |perm|
            @user_permissions[ministry][perm.controller] ||= []
            @user_permissions[ministry][perm.controller] << perm.action
          end
        end
      end
      
      action ||= ['create','destroy'].include?(action_name.to_s) ? 'new' : action_name.to_s
      action = action == 'update' ? 'edit' : action
#      # Code to potentially replace the action assignment lines above.
#      action ||= PERMISSION_MAPPING['*init'].include?(action_name.to_s) ? 
#                   PERMISSION_MAPPINGS['*init'][action_name.to_s][:action] : action_name.to_s
#      action = PERMISSION_MAPPING['*'].include?(action) ? 
#                   PERMISSION_MAPPINGS['*'][action][:action] : action

      controller ||= controller_name.to_s

      # Make sure we're always using strings      
      action = action.to_s
      controller = controller.to_s     
      
      # Check if the action is mapped in the Permission Mappings Hash. If so, use that mapping.
      #if PERMISSION_MAPPINGS[controller] && (mapped_permission = PERMISSION_MAPPINGS[controller][action])
      #  action = mapped_permission[:action]
      #  controller = mapped_permission[:controller] || controller
      #end

      # Owner Action Checking
      # NOTE: These need to be done after action & controller are set
      if AUTHORIZE_FOR_OWNER_ACTIONS[controller.to_sym] &&
        AUTHORIZE_FOR_OWNER_ACTIONS[controller.to_sym].include?(action.to_sym)
        case controller.to_sym
        when :people
          if (params[:id] && params[:controller] == "people") && params[:id] == @my.id.to_s
            return true
          end
        when :profile_pictures, :timetables
          if params[:person_id] && params[:person_id] == @my.id.to_s
            return true
          end
        when :groups
          if (params[:id] && params[:controller] == "groups") && 
            @my.group_involvements.find(:first, :conditions => { :id => params[:id], :level => [ 'co-leader', 'leader' ]})
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
        @ministry = session[:ministry_id] ?
          @person.ministries.find(:first, :conditions => {:id => session[:ministry_id] }) :
          @person.ministries.first


        # If we didn't get a ministry out of that, check for a ministry through campus
        @ministry ||= @person.campus_involvements.first.ministry unless @person.campus_involvements.empty? 

        # If we still don't have a ministry, this person hasn't been assigned a campus.
        # Looks like we have to give them some dummy information. BUG 1857 
        @ministry ||= associate_person_with_default_ministry(@person)


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
    
    def get_person_campus_groups
      groups = Group.find :all, :conditions => {:ministry_id => @ministry.id}
      @person_campus_groups = groups.select{|g| g.campus.nil? || @my.campuses.find_by_id(g.campus_id)}
    end
    
private
  # Ensures that the _person_ is involved in the 'No Ministry' ministry
  # BUG 1857
  def associate_person_with_default_ministry(person)
    if Cmt::CONFIG[:associate_with_default_ministry]
      default_ministry = Cmt::CONFIG[:default_ministry_name]
    else
      default_ministry = 'No Ministry'
    end
    # Ensure the default ministry exists
    ministry = Ministry.find_or_create_by_name(default_ministry)
    sr = StudentRole.find_by_name 'Student' 
    sr ||= StudentRole.find :last, :order => "position"
    person.ministry_involvements.create! :ministry_id => ministry.id, :ministry_role_id => sr.id
    
    ministry
  end
end
