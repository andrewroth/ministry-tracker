# This controller handles the login/logout function of the site.  
require 'soap/wsdlDriver'
require 'soap/mapping'
require 'defaultDriver'
class SessionsController < ApplicationController
  skip_before_filter :login_required, :get_person, :get_ministry
  # render new.rhtml
  def new
    if logged_in?
      redirect_back_or_default(person_url(self.current_user.person))
    end
    # raise cookies[:auth_token].inspect
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
        args = GetSsoUserFromServiceTicket.new(session[:return_to], ticket)
        details = cas.getSsoUserFromServiceTicket(args).getSsoUserFromServiceTicketResult
        # Look for a user with this guid
        u = User.find(:first, :conditions => _(:guid, :user) + " = '#{details.userID}'")
        # if we have a user by this method, great! update the email address if it doesn't match
        if u
          if u.username != details.email
            u.username = details.email
            u.save
          end
        else
          # If we didn't find a user with the guid, do it by email address and stamp the guid
          u = User.find(:first, :conditions => _(:username, :user) + " = '#{details.email}'")
          if u
            u.guid = details.userID
            u.save
          else
            # If we still don't have a user in SSM, we need to create one.
            u = User.create!(:username => details.email, :guid => details.userID)
          end
        end
        # make sure we have a person
        unless u.person
          u.person = Person.new(:first_name => details.firstName, :last_name => details.lastName)
          u.person.current_address = CurrentAddress.new(:email => details.email)
          u.person.save(false)
        end
        self.current_user = u || :false
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
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end
end
