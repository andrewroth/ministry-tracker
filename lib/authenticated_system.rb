require 'hpricot'
module AuthenticatedSystem
  protected
    # Returns true or false if the user is logged in.
    # Preloads @current_user with the user model if they're logged in.
    def logged_in?
      current_user != :false
    end
    
    # Accesses the current user from the session.  Set it to :false if login fails
    # so that future calls do not hit the database.
    def current_user
      @current_user ||= (login_from_session || login_from_basic_auth || login_from_cookie || login_from_cas || login_from_fb || :false)
    end
    
    # Store the given user in the session.
    def current_user=(new_user)
      session[:user] = (new_user.nil? || new_user.is_a?(Symbol)) ? nil : new_user.id
      @current_user = new_user
    end
    
    # Check if the user is authorized
    #
    # Override this method in your controllers if you want to restrict access
    # to only a few actions or if you want to check if the user
    # has the correct rights.
    #
    # Example:
    #
    #  # only allow nonbobs
    #  def authorized?
    #    current_user.login != "bob"
    #  end
    # def authorized?
    #   logged_in?
    # end

    # Filter method to enforce a login requirement.
    #
    # To require logins for all actions, use this in your controllers:
    #
    #   before_filter :login_required
    #
    # To require logins for specific actions, use this in your controllers:
    #
    #   before_filter :login_required, :only => [ :edit, :update ]
    #
    # To skip this in a subclassed controller:
    #
    #   skip_before_filter :login_required
    #
    def login_required
      logged_in? || access_denied
    end

    # Redirect as appropriate when an access request fails.
    #
    # The default action is to redirect to the login screen.
    #
    # Override this method in your controllers if you want to have special
    # behavior in case the user is not authorized
    # to access the requested action.  For example, a popup window might
    # simply close itself.
    def access_denied(no_destination = false)
      respond_to do |accepts|
        accepts.html do
          store_location unless no_destination
          if facebook_session
            redirect_to prompt_for_email_users_path
          else
            redirect_to :controller => '/sessions', :action => 'new'
          end
        end
        accepts.xml do
          headers["Status"]           = "Unauthorized"
          headers["WWW-Authenticate"] = %(Basic realm="Web Password")
          render :text => "Couldn't authenticate you", :status => '401 Unauthorized'
        end
      end
      false
    end  
    
    # Store the URI of the current request in the session.
    #
    # We can return to this location by calling #redirect_back_or_default.
    def store_location
      session[:return_to] = request.request_uri
    end
    
    # Redirect to the URI stored by the most recent store_location call or
    # to the passed default.
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
    
    # Inclusion hook to make #current_user and #logged_in?
    # available as ActionView helper methods.
    def self.included(base)
      base.send :helper_method, :current_user, :logged_in?
    end

    # Called from #current_user.  First attempt to login by the user id stored in the session.
    def login_from_session
      self.current_user = User.find(:first, :conditions => "#{_(:id, :user)} = #{session[:user]}") if session[:user]
    end

    # Called from #current_user.  Now, attempt to login by basic authentication information.
    def login_from_basic_auth
      username, passwd = get_auth_data
      self.current_user = User.authenticate(username, passwd) if username && passwd
    end

    # Called from #current_user.  Finaly, attempt to login by an expiring token in the cookie.
    def login_from_cookie      
      user = cookies[:auth_token] && User.find_by_remember_token(cookies[:auth_token])
      if user && user.remember_token?
        user.remember_me
        cookies[:auth_token] = { :value => user.remember_token, :expires => user.remember_token_expires_at }
        self.current_user = user
      end
    end
    
    def login_from_cas
      cas_user = session[:cas_user]
      u = false
      if cas_user
        u = User.find_or_create_from_cas(session[:cas_last_valid_ticket])
        self.current_user = u
      end
    end
    
    def login_from_fb
      if facebook_session
        self.current_user = User.find_by_fb_user(facebook_session.user)
      end
    end

    def authenticate_from_group_invitation
      unless check_and_increment_login_code(params[:login_code], GroupInvitation) == true
        flash[:notice] = "We're sorry, the link you came from is no longer valid"
        access_denied(true)
      end
    end
    
    def authenticate_from_api_key
      unless check_and_increment_login_code(params[:api_key], ApiKey) == true
        respond_to do |format|
          format.xml { render :xml => "<error><type>Authentication</type><message>API key not valid</message></error>", :status => 401 }
        end
        return
      else
        @api_key_user = ApiKey.first(:joins => [:login_code], :conditions => {:login_codes => {:code => params[:api_key]}}).try(:user)
      end
    end
    
    def logout_keeping_session!(redirect_path_if_no_cas = nil, force_cas_logout = nil, redirect = true)
      # Kill server-side auth cookie
      @current_user.forget_me if @current_user.is_a? User
      @current_user = false     # not logged in, and don't do it for me
      kill_remember_cookie!     # Kill client-side auth cookie
      # explicitly kill any other session variables you set
      need_cas_logout = false
      if (session[:cas_user] || force_cas_logout == true) && force_cas_logout != false
        need_cas_logout = true
      end
      clear_session
      
      unless redirect == false
        # Log out of SSO if we're in it
        if need_cas_logout
          CASClient::Frameworks::Rails::Filter.logout(self, new_session_url)
        else
          redirect_path_if_no_cas.present? ? redirect_back_or_default(redirect_path_if_no_cas) : redirect_back_or_default(new_session_path)
        end
      end
    end
    
    def logout_without_redirect!
      logout_keeping_session!(nil, nil, false)
    end
  
    def clear_session
      session.clear
    end

    def kill_remember_cookie!
      cookies.delete :auth_token
    end

  private
    @@http_auth_headers = %w(Authorization HTTP_AUTHORIZATION X-HTTP_AUTHORIZATION X_HTTP_AUTHORIZATION REDIRECT_X_HTTP_AUTHORIZATION)

    # gets BASIC auth info
    def get_auth_data
      auth_key  = @@http_auth_headers.detect { |h| request.env.has_key?(h) }
      auth_data = request.env[auth_key].to_s.split unless auth_key.blank?
      return auth_data && auth_data[0] == 'Basic' ? Base64.decode64(auth_data[1]).split(':')[0..1] : [nil, nil] 
    end
        
        
    # code - the login code
    # has_login_code_class - class that has a login_code association (we don't want to access just any login code, but one that is associated with a particular class)
    def check_and_increment_login_code(code, has_login_code_class)
      you_shall_pass = false
      
      if code.present?
        logout_without_redirect! if logged_in? # make sure if there is an existing session that it doesn't conflict
        
        lc = has_login_code_class.first(:joins => [:login_code], :conditions => {:login_codes => {:code => code}}).try(:login_code)
        
        if lc.present? && lc.acceptable?
          you_shall_pass = true
          lc.increment_times_used
          session[:login_code_id] = lc.id
        end
      end
      
      you_shall_pass
    end
end
