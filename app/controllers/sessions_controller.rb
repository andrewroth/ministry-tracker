# This controller handles the login/logout function of the site.  
require 'soap/wsdlDriver'
require 'soap/mapping'
require 'defaultDriver'
class SessionsController < ApplicationController
  skip_before_filter :login_required, :get_person, :get_ministry
  
  filter_parameter_logging :password
  # render new.rhtml
  def new
    if logged_in?
      redirect_back_or_default(person_url(self.current_user.person))
    end
    if params[:errorKey] == 'BadPassword'
      flash[:warning] = "Invalid username or password"
    end
  end

  def create
    # First try SSM
    respond_to do |wants|
      if params[:username].blank? || params[:password].blank?
        flash[:warning] = "Invalid username or password"
        wants.js {}
      else
        self.current_user = User.authenticate(params[:username], params[:password])
        if logged_in?
          if params[:remember_me] == "1"
            self.current_user.remember_me
            cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
          end
          flash[:notice] = "Logged in successfully"
          wants.js do
            render :update do |page| 
              page.redirect_to(session[:return_to] || person_path(self.current_user.person)) 
            end
          end
        else
          # If regular auth didn't work, see if they used CAS credentials
          cas = TntWareSSOProviderSoap.new
          args = GetServiceTicketFromUserNamePassword.new(new_session_url, params[:username], params[:password], request.remote_ip)
          begin
            ticket = cas.getServiceTicketFromUserNamePassword(args).getServiceTicketFromUserNamePasswordResult 
          rescue Timeout::Error
          rescue
            # Auth failed
          end
          unless ticket.to_s.empty?
            # Valid CAS user. do the redirect for SSO
            
            wants.js {render :action => 'post_to_cas'}
          else
            # No luck. tell them they're a screwup
            flash[:warning] = "Invalid username or password"
            wants.js {}
          end
        end
      end
    end
  end

  def destroy
    flash[:notice] = "You have been logged out."
    logout_keeping_session!
  end
  
  def boom
    raise StandardError, 'hi toad'
  end
end
