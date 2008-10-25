# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include ExceptionNotifiable

  # Pick a unique cookie name to distinguish our session data from others'
  helper_method :date_format, :_, :receipt, :is_ministry_leader, :is_ministry_leader_somewhere, :bible_study_admin, :team_admin, :get_ministry, :current_user
  before_filter :login_required, :get_person, :get_ministry
  
  skip_before_filter CAS::Filter  
  # prepend_before_filter :local_auth_bypass
  #   
  def boom
    raise 'testing error notification'
  end
  
  protected
    # =============================================================================
    # = See lib/load_mappings.rb                                                  =
    # =============================================================================
    def _(column, table)
      ActiveRecord::Base._(column, table)
    end
    
    def date_format(value)
      return '' if value.to_s.empty?
      value = value.to_s
      time = value.class == Time ? value : Time.parse(value)
      time.strftime('%m/%d/%Y')
    end
    
    def get_person
      @person = params[:person_id] ? Person.find(params[:person_id]) : nil
      # Initialize the logged in person
      @me = @my = @current_user.person
      
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
      ministry ||= get_ministry
      if person
        return ministry.staff.include?(person)
      else
        return ministry.staff.include?(@me)
      end
    end
    
    def is_ministry_leader_somewhere
      @is_ministry_leader ||= !MinistryInvolvement.find(:first, :conditions => ["#{_(:person_id, :ministry_involvement)} = ? AND #{_(:ministry_role, :ministry_involvement)} IN ('Director','Staff')", @my.id]).nil?
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
    
    def local_auth_bypass
      session[CAS::Filter::session_username] = 'josh.starcher@uscm.org'
      receipt = Object.new()
      receipt.class.class_eval "def guid() '4327987'; end"
    end
end
