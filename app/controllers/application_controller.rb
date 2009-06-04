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
  before_filter CASClient::Frameworks::Rails::GatewayFilter unless Rails.env.test?
  #    use this line for production  
  before_filter :login_required, :get_person, :get_ministry, :set_locale#, :get_bar
#  before_filter :fake_login, :login_required, :get_person, :get_ministry, :set_locale#, :get_bar
  before_filter :authorization_filter
  
  helper :all

  protected
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
      @countries = Country.find(:all,
        :conditions => "#{_(:is_closed, :country)} = 0 || #{_(:is_closed, :country)} is null", 
        :order => _(:country, 'country'))
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
      controller ||= controller_name.to_s
      # First see if this is restricted in the permissions table
      permission = Permission.find(:first, :conditions => {_(:action, :permission) => action.to_s, _(:controller, :permission) => controller.to_s})
      if permission
        unless @user_permissions[ministry][permission.controller] && @user_permissions[ministry][permission.controller].include?(permission.action)
          return false 
        end
      end
      return true
    end
    
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
    
    def get_people_responsible_for
      @people_responsible_for = @person.people_responsible_for
    end

    def get_people_in_ministry_campus
      m = get_ministry
      mi = m.ministry_involvements
      higher_mi_array = []
      mi.each do |cur_mi|
      if cur_mi.ministry_role.position < @person.ministry_involvements.find(:first, :conditions => {:ministry_id => m.id}).ministry_role.position # fix this ASAP, right after it runs...
          higher_mi_array << cur_mi
        end
      end
      @people_in_ministry_campus = []
      higher_mi_array.each do |h_mi|
        person = h_mi.person
        unless person.campus_involvements.find(:first).nil?
          unless @person.campus_involvements.find(:first).campus.nil?
            if person.campus_involvements.find(:first).campus == @person.campus_involvements.find(:first).campus
              @people_in_ministry_campus << person
            end
          end
        end
      end
      
      
      
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
        @ministry = session[:ministry_id] ? Ministry.find(session[:ministry_id]) : @person.ministries.first
        # If we didn't get a ministry out of that, check for a ministry through campus
        @ministry ||= @person.campus_involvements.first.ministry unless @person.campus_involvements.empty? 

        # Try the default ministry given in the config
        if Cmt::CONFIG[:default_ministry_name]
          @ministry ||= Ministry.find :first, :conditions => { :name => Cmt::CONFIG[:default_ministry_name] }
        end

        # If we still don't have a ministry, this person hasn't been assigned a campus.
        # Looks like we have to give them some dummy information. BUG 1857 
        @ministry ||= associate_person_with_dummy_ministry(@person)

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
    
private
  # Ensures that the _person_ is involved in the 'No Ministry' ministry
  # BUG 1857
  def associate_person_with_dummy_ministry(person)
    # Ensure the 'No Ministry' ministry exists
    ministry = Ministry.find_or_create_by_name("No Ministry")
    sr = StudentRole.find :last, :order => "position"
    person.ministry_involvements.create! :ministry_id => ministry.id, :ministry_role_id => sr.id
    
    ministry
  end
end
