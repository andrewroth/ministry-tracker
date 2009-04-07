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
      @current_user ||= (login_from_api_key || login_from_session || login_from_basic_auth || login_from_cookie || login_from_cas || login_from_facebook || :false)
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
    def access_denied
      respond_to do |accepts|
        accepts.html do
          store_location
          redirect_to :controller => '/sessions', :action => 'new'
        end
        accepts.xml do
          headers["Status"]           = "Unauthorized"
          headers["WWW-Authenticate"] = %(Basic realm="Web Password")
          render :text => "Could't authenticate you", :status => '401 Unauthorized'
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
    
    def login_from_facebook
      if fbsession.ready?
        u = User.find_from_facebook(fbsession)
        self.current_user = u
      end
    end

    def login_from_api_key
      # TODO: should have a version param?
      # TODO: should have a timestamp param and check within 15 minute interval?
      return false unless params.has_key?(:api_key) 

      u = User.find_by_api_key(params[:api_key])
      local_params = params.dup
      local_params.delete_if {|key, value| ['format', 'submit', 'action','controller','commit','search'].include?(key)}
 
      return false unless local_params.has_key?(:signature)
      signature_param = local_params[:signature]
      local_params.delete(:signature)
      local_params.each{|k, v| local_params[k] = v.join(",") if v.is_a?(Array)}
 
      return false unless signature_param == signature_helper(local_params, u.secret_key)

      self.current_user = u
    end
    
    def logout_keeping_session!
      # Kill server-side auth cookie
      @current_user.forget_me if @current_user.is_a? User
      @current_user = false     # not logged in, and don't do it for me
      kill_remember_cookie!     # Kill client-side auth cookie
      # explicitly kill any other session variables you set
      need_cas_logout = false
      if session[:cas_user]
        need_cas_logout = true
      end
      session[:cas_user] = nil
      session[:user] = nil   # keeps the session but kill our variable
      session[:ministry_id] = nil
      # Log out of SSO if we're in it
      if need_cas_logout
        CASClient::Frameworks::Rails::Filter.logout(self, new_session_url)
      else
        redirect_back_or_default(new_session_path)
      end
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

    def signature_helper(params, secret_key)
      args = []
      params.each{|k, v| args << "#{k}=#{v}"}
      sorted = args.sort
      request = sorted.join("")
      Digest::MD5.hexdigest("#{request}#{secret_key}")
    end
end
