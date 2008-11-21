# This controller handles the login/logout function of the site.  
require 'soap/wsdlDriver'
require 'soap/mapping'
require 'defaultDriver'
class SessionsController < ApplicationController
  skip_before_filter :login_required, :get_person, :get_ministry
  before_filter :try_cas, :only => :new
  
  filter_parameter_logging :password
  # render new.rhtml
  def new
    if logged_in?
      redirect_back_or_default(person_url(self.current_user.person))
    end
  end

  def create
    # First try SSM
    self.current_user = User.authenticate(params[:login], params[:plain_password])
    # Then try CAS
    unless logged_in?
      # session[:return_to] = request.protocol + request.host_with_port
      cas = TntWareSSOProviderSoap.new
      args = GetServiceTicketFromUserNamePassword.new(session[:return_to], params[:login], params[:plain_password], request.remote_ip)
      # A little debug code can save the day
      log = ''
      cas.wiredump_dev = log
      begin
        ticket = cas.getServiceTicketFromUserNamePassword(args).getServiceTicketFromUserNamePasswordResult 
      rescue
        # Auth failed
      end
      unless ticket.to_s.empty?
        
      end
    end
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      # put the person in the session
      # person = self.current_user.person || self.current_user.person.create
      session[:person_id] = self.current_user.person.id
      redirect_back_or_default(person_path(self.current_user.person))
      flash[:notice] = "Logged in successfully"
    else
      flash[:warning] = "Invalid username or password"
      render :action => 'new'
    end
  end

  def destroy
    logout_keeping_session!
    flash[:notice] = "You have been logged out."
  end
  
  def boom
    raise StandardError, 'hi toad'
  end
end
