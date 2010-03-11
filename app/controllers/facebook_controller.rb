class FacebookController < ApplicationController
  skip_before_filter :login_required
  skip_before_filter CASClient::Frameworks::Rails::GatewayFilter
  skip_before_filter :authorization_filter
  skip_before_filter :get_ministry
  skip_before_filter :force_required_data

  def tabs
    respond_to do |wants|
      wants.xml { render :layout => false }
    end
  end
  
  def bible_studies
    render :layout => false
  end
  
  def training
    render :layout => false
  end
  
  def install
    render :nothing => true
  end
  
  def remove
    render :nothing => true
  end
  
  def login
    # finish_facebook_login
    # if @user
    # return unless require_facebook_login(:next => url_for(:controller => '/'))
    # return authenticate_facebook_user
    # redirect_to person_path(@person)
    render :nothing => true
    # else
      # redirect_to '/'
   end
  
end
