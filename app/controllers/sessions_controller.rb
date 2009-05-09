# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  skip_before_filter :login_required, :get_person, :get_ministry, :authorization_filter
  
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
    if params[:username].blank? || params[:password].blank?
      flash[:warning] = "Username and password can't be blank"
      render :action => :new
    else
      # First try SSM
      self.current_user = User.authenticate(params[:username], params[:password])
      if logged_in?
        if params[:remember_me] == "1"
          self.current_user.remember_me
          cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
        end
        flash[:notice] = "Logged in successfully"
        redirect_to(session[:return_to] || person_path(self.current_user.person)) 
      else
        # If regular auth didn't work, see if they used CAS credentials
        form_params = {:username => params[:username], :password => params[:password], :service => new_session_url }
        cas_url = 'https://signin.mygcx.org/cas/login'
        agent = WWW::Mechanize.new
        page = agent.post(cas_url, form_params)
        result_query = page.uri.query
        unless result_query && result_query.include?('BadPassword')
          redirect_to(cas_url + '?service=' + new_session_url + '&username=' + params[:username] + '&password=' + params[:password])
        else
          # No luck. tell them they're a screwup
          logger.debug(page.uri)
          flash[:warning] = "Invalid username or password"
          render :action => :new
        end
      end
    end
  end

  def destroy
    flash[:notice] = "You have been logged out."
    logout_keeping_session!
  end
  
end
