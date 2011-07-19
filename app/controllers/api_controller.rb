class ApiController < ApplicationController
  unloadable
  
  api_key_authentication
  before_filter :log_api_call
  before_filter :get_current_user_from_guid_param
  after_filter :after_api_call
  
  ERROR = {}
  ERROR[:MISSING_PARAM] = "missing expected parameter(s)"
  ERROR[:NO_USER_FOUND] = "no users found for the given parameters"
  
  
  def authorized
    begin
      
      if params[:a] && params[:c] && @current_user
        
        get_person
        get_ministry
        
        result = (authorized?(params[:a], params[:c]) == true)
        
        respond_to do |format|
          format.xml { render :xml => "<authorized action='#{params[:a]}' controller='#{params[:c]}'>#{result}</authorized>" }
        end
      else
        raise ERROR[:MISSING_PARAM]
      end
      
    rescue => e
      respond_to do |format|
        format.xml { render :xml => error_xml(e), :status => 400 }
      end
    end
  end
  
  
  def ministry_involvements
    @ministry_involvements = @my.ministry_involvements
    
    respond_to do |format|
      format.xml {
        render :xml => "#{ministry_involvements_to_xml(@ministry_involvements,
                            {:first_name => @my.first_name, :last_name => @my.last_name, :email => @my.email, :guid => @my.user.guid})}"
      }
    end
  end
  
  
  
  private
  
  def after_api_call
    logout_without_redirect!
  end
  
  
  def get_current_user_from_guid_param
    begin
      
      if params[:guid]
        user = User.find_by_guid(params[:guid])
        raise ERROR[:NO_USER_FOUND] unless user
        @current_user = user
        get_person
        get_ministry
      else
        raise ERROR[:MISSING_PARAM]
      end
      
    rescue => e
      respond_to do |format|
        format.xml { render :xml => error_xml(e), :status => 400 }
      end
      return
    end
  end
  
  
  def log_api_call
    Rails.logger.info("API CALL (#{Date.today}, user:#{@api_key_user.id}, ip:#{request.remote_ip}, url:\"#{request.url}\")")
  end
  
  
  def error_xml(e)
    # only show constant error messages to ensure no special characters mess with xml formatting
    "<error><type>#{e.class.to_s}</type><message>#{ ERROR.detect{|k,v| v == e.message}.try(:at, 1) }</message></error>"
  end
  
  
  def ministry_involvements_to_xml(mis, attributes = {})
    mis = ([] << mis).flatten
    
    xml = Builder::XmlMarkup.new(:target => xml_string = "")
    
    xml.ministry_involvements(attributes) do
      mis.each do |mi|
        xml.ministry_involvement do
          xml.role(:type => mi.ministry_role.type, :name => mi.ministry_role.name) {}
          xml.start_date mi.start_date
          xml.last_history_update_date mi.last_history_update_date
          xml.ministry(:name => mi.ministry.name) do
            mi.ministry.unique_campuses.each do |c|
              xml.campus(:name => c.name) {}
            end
          end
        end
      end
    end
    
    xml_string
  end
end


