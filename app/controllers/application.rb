require 'hoptoad_notifier'
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
                :get_ministry, :current_user, :is_ministry_admin, :authorized?, :is_group_leader
  before_filter CASClient::Frameworks::Rails::GatewayFilter unless Rails.env.test?
  before_filter :login_required, :get_person, :get_ministry, :set_locale#, :get_bar
  before_filter :authorization_filter

  protected    
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
      #TODO: need to improve figuring out what ministries to list. 
    end
    
    def get_countries
      @countries = Country.find(:all, :conditions => "#{_(:is_closed, :country)} = 0", :order => _(:country, 'country'))
    end

    def is_group_leader(group, person = nil)
      person ||= @me
      return group.leaders.include?(person) || authorized?(:edit, :bible_studies)
    end
    
    def is_ministry_leader( ministry = nil, person = nil)
      ministry ||= @ministry || get_ministry
      person ||= @me
      involvement = person.ministry_involvements.detect {|mi| mi.ministry_id == ministry.id}
      return ministry.staff.include?(person) || (involvement && involvement.admin?)
    end
    
    def is_ministry_leader_somewhere(person = nil)
      person ||= @me
      @is_ministry_leader ||= {}
      @is_ministry_leader[person.id] ||= !MinistryInvolvement.find(:first, :conditions => 
                                          ["#{_(:person_id, :ministry_involvement)} = ? AND (#{_(:ministry_role_id, :ministry_involvement)} IN (?) OR admin = 1)", 
                                            @my.id, get_ministry.root.leader_roles_ids]).nil?
    end
    
    def is_involved_somewhere(person = nil)
      person ||= @me
      return MinistryInvolvement.find(:first, :conditions => ["#{_(:person_id, :ministry_involvement)} = ? AND #{_(:ministry_role_id, :ministry_involvement)} IN (?)", person.id, get_ministry.involved_student_role_ids])
    end
    
    def is_ministry_admin(ministry = nil, person = nil)
      @admins ||= {}
      ministry ||= get_ministry
      @admins[ministry.id] ||= {}
      person ||= @me
      unless @admins[ministry.id][person.id]
        @admins[ministry.id][person.id] = person.admin?(ministry)
      end
      return @admins[ministry.id][person.id]
    end
    
    def authorized?(action = nil, controller = nil)
      return true if is_ministry_admin
      unless @user_permissions
        @user_permissions = {}
        # Find the highest level of access they have at or above the level of the current ministry
        mi = @my.ministry_involvements.find(:first, :conditions => ["#{MinistryInvolvement.table_name + '.' + _(:ministry_id, :ministry_involvement)} IN (?)", get_ministry.ancestor_ids], :joins => :ministry_role, :order => _(:position, :ministry_role))
        return false unless mi
        role = mi.ministry_role
        role.permissions.each do |perm|
          @user_permissions[perm.controller] ||= []
          @user_permissions[perm.controller] << perm.action
        end
      end
      action ||= ['create','destroy'].include?(action_name.to_s) ? 'new' : action_name.to_s
      action = action == 'update' ? 'edit' : action
      controller ||= controller_name.to_s
      # First see if this is restricted in the permissions table
      permission = Permission.find(:first, :conditions => {_(:action, :permission) => action.to_s, _(:controller, :permission) => controller.to_s})
      if permission
        unless @user_permissions[permission.controller] && @user_permissions[permission.controller].include?(permission.action)
          return false 
        end
      end
      return true
    end
    
    def authorization_filter
      unless authorized?
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
      locales = ['en-US', 'en-AU']
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
      @me = @my = current_user.person
      
      # if we didn't get a person in the params, set it now
      @person ||= @me
      
      if @person.nil?
        redirect_to '/sessions/new'
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
        # If we still don't have a ministry, this person hasn't been assigned a campus. 
        # Give them the default ministry
        @ministry ||= Ministry.find_or_create_by_name("No Ministry")
        
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
    
end
