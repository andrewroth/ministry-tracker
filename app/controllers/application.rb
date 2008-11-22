require 'hoptoad_notifier'
require 'cgi'
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include HoptoadNotifier::Catcher
  
  self.allow_forgery_protection = false

  # Pick a unique cookie name to distinguish our session data from others'
  helper_method :format_date, :_, :receipt, :is_ministry_leader, :is_ministry_leader_somewhere, :bible_study_admin, :team_admin, 
                :get_ministry, :current_user, :is_ministry_admin
  before_filter CASClient::Frameworks::Rails::GatewayFilter unless Rails.env.test?
  before_filter :login_required, :get_person, :get_ministry, :set_locale#, :get_bar

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
    
    # cas receipt
    def receipt
      @receipt || session[:casfilterreceipt]
    end
    
    def is_ministry_leader( ministry = nil, person = nil)
      ministry ||= @ministry || get_ministry
      if person
        return ministry.staff.include?(person)
      else
        return ministry.staff.include?(@me)
      end
    end
    
    def is_ministry_leader_somewhere(person = nil)
      person ||= @me
      @is_ministry_leader ||= {}
      @is_ministry_leader[person.id] ||= !MinistryInvolvement.find(:first, :conditions => ["#{_(:person_id, :ministry_involvement)} = ? AND #{_(:ministry_role, :ministry_involvement)} IN ('Director','Staff')", @my.id]).nil?
    end
    
    def is_involved_somewhere(person = nil)
      person ||= @me
      return CampusInvolvement.find(:first, :conditions => ["#{_(:person_id, :campus_involvement)} = ? AND #{_(:ministry_role, :campus_involvement)} IN (?)", person.id, CampusInvolvement::INVOLVED_ROLES])
    end
    
    def is_ministry_admin(ministry = nil, person = nil)
      @admins ||= {}
      ministry ||= @ministry || get_minsitry
      person ||= @person
      unless @admins[:ministry_id]
        mi = MinistryInvolvement.find_by_person_id_and_ministry_id(person.id, ministry.id)
        mi ? @admins[:ministry_id] = mi.admin? : false
      end
      logger.debug("Admin: #{@admins[:ministry_id]}")
      return @admins[:ministry_id]
    end
    
    def bible_study_admin
      is_ministry_leader ? true : false
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
    
    def e(str)
      ApplicationController::escape_string(str)
    end
      
    def escape_string(str)
      ApplicationController::escape_string(str)
    end
    
    def self.escape_string(str)
      str.gsub(/([\0\n\r\032\'\"\\])/) do
        case $1
        when "\0" then "\\0"
        when "\n" then "\\n"
        when "\r" then "\\r"
        when "\032" then "\\Z"
        else "\\"+$1
        end
      end
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
        @ministry = Ministry.find(params[:ministry_id]) unless @ministry && @ministry.id == params[:ministry_id]
      end
      unless is_ministry_admin(@ministry, @me)
        render :nothing => true 
        return false
       end
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
      # Get my bible study involvements
      @personal_bible_studies = @my.bible_studies
      # if get_ministry
      #   @personal_bible_studies = BibleStudy.find(:all, :conditions => ["#{_(:ministry_id, :group)} = ? AND #{_(:person_id, :group_involvement)} = ?",
      #                                                                 @ministry.id, @person.id],
      #                                                   :include => :group_involvements)
      # else
      #   @personal_bible_studies = []
      # end
    end
    
    def get_ministry
      @person ||= get_person
      raise "no person" unless @person
      unless @ministry
        @ministry = session[:ministry_id] ? Ministry.find(session[:ministry_id]) : @person.ministries.first
        # If we didn't get a ministry out of that, check for a ministry through campus
        @ministry ||= @person.campus_involvements.first.ministry unless @person.campus_involvements.empty? 
        # If we still don't have a ministry, this person hasn't been assigned a campus. Give them the 
        # default ministry
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
