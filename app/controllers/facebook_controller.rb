class FacebookController < ApplicationController
  skip_before_filter CASClient::Frameworks::Rails::GatewayFilter, :login_required, :authorization_filter, :get_person, :get_ministry
  before_filter :require_facebook_login, :except => [:no_access, :login]
  before_filter :authenticate_facebook_user, :except => [:no_access, :login]
  layout 'facebook'
  
  def index
    # @person = @user.person
    unless params[:next].blank?
      redirect_to(params[:next])
    else
      setup_involvement_vars
    end
  end
  
  
  def profile
    
  end
  
  def no_access
    if fbparams && fbparams['in_canvas'] == '1'
      render :text => "Sorry, you don't have access to this app."
    else
      render :layout => 'sessions'
    end
  end
  
  def login
    # finish_facebook_login
    # if @user
    return unless require_facebook_login(:next => url_for(:controller => '/'))
    return authenticate_facebook_user
    redirect_to person_path(@person)
    # else
      # redirect_to '/'
  end

  def finish_facebook_login
    # redirect to whatever your want your after-login landing page to be
    @user = User.find_from_facebook(fbsession)
    session[:user] = @user.id if @user
    self.current_user = @user
  end
  
  def authenticate_facebook_user
    @user = User.find(session[:user]) if session[:user]
    @user ||= User.find_from_facebook(fbsession) 
    unless @user
      redirect_to :action => 'no_access'
      return false
    else
      self.current_user = @user
      session[:user] = @user.id
      get_person
      get_ministry
    end
  end

end
