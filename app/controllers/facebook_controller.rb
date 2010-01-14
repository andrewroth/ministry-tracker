class FacebookController < ApplicationController
  skip_before_filter :login_required
  skip_before_filter CASClient::Frameworks::Rails::GatewayFilter
  skip_before_filter :authorization_filter
  skip_before_filter :get_ministry
  skip_before_filter :force_campus_set

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
  
end
