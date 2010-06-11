# This controller handles the login/logout function of the site.  
# Question: Two means for logging in -  first tries local login , then tries
# a login via GCX's CAS
class SessionsController < ApplicationController
  skip_before_filter :login_required, :get_person, :get_ministry, :authorization_filter, :force_required_data
  filter_parameter_logging :password

  def crash
    throw("Forced crash.  env: #{RAILS_ENV}")
  end

  def new_gcx
    get_person
    get_ministry if @person
  end

  # render new.rhtml
  def new
    if logged_in?
      if self.current_user.respond_to?(:login_callback) 
        self.current_user.login_callback
      end
      self.current_user.last_login = Time.now
      self.current_user.save
      redirect_back_or_default(:controller => 'dashboard', :action => 'index')
    end
    # force a flash warning div to show up, so that invalid password message can be shown
    flash[:warning] = '&nbsp;'
    if params[:errorKey] == 'BadPassword'
      flash[:warning] = "Invalid username or password"
    end

  end

  def create
    respond_to do |wants|
      if params[:username].blank? || params[:password].blank?
        flash[:warning] = "Username and password can't be blank"
        wants.js {}
        wants.html { render :action => :new }
      else
        if Cmt::CONFIG[:local_direct_logins]
          # First try SSM
          self.current_user = User.authenticate(params[:username], params[:password])
        end
        if Cmt::CONFIG[:local_direct_logins] && logged_in?
          if self.current_user.respond_to?(:login_callback)
            self.current_user.login_callback
          end
          if params[:remember_me] == "1"
            self.current_user.remember_me
            cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
          end
          flash[:notice] = "Logged in successfully"
          # local login worked, redirect to appropriate starting page
          self.current_user.last_login = Time.now
          self.current_user.save
          redirect_params = session[:return_to] || url_for(:controller => 'dashboard', :action => 'index')
          wants.js do
            render :update do |page|
              page.redirect_to(redirect_params)
            end
          end
          wants.html do
            redirect_to(redirect_params)
          end
        elsif Cmt::CONFIG[:gcx_direct_logins]
          # If regular auth didn't work, see if they used CAS credentials
          form_params = {:username => params[:username], :password => params[:password], :service => new_session_url }
          cas_url = 'https://signin.mygcx.org/cas/login'
          begin
            agent = Mechanize.new
            page = agent.post(cas_url, form_params)
            result_query = page.uri.query
          rescue Errno::ECONNREFUSED
            failed = true
          end
          unless failed || (result_query && result_query.include?('BadPassword'))
            # password is correct, send client to gcx to get gcx session set
            redirect_url = cas_url + '?service=' + new_session_url + '&username=' + params[:username] + '&password=' + params[:password]
            wants.html do
              redirect_to(redirect_url)
            end
            wants.js do
              render :update do |page|
                page.redirect_to(redirect_url)
              end
            end
          else
            # No luck. tell them they're a screwup
            flash[:warning] = "Invalid username or password"
            wants.js { }
            wants.html { render :action => :new }
          end
        else
          flash[:warning] = "Local logins are disabled."
          wants.html { render :action => :new }
        end
      end
    end
  end

  def destroy
    if session[:impersonator].present?
      clear_session
      session[:user] = session[:impersonator]
      session[:impersonator] = nil
      redirect_to :back
    else
      flash[:notice] = "You have been logged out."
      logout_keeping_session!
    end
  end
    

end
