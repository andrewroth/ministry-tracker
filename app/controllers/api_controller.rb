class ApiController < ApplicationController
  unloadable
  
  api_key_authentication
  after_filter :after_api_call
  
  
  def authorized
    if params[:a] && params[:c] && params[:u] && @current_user = User.find_by_username(params[:u]).first
      
      get_person
      get_ministry
      
      render :text => authorized?(params[:a], params[:c]) == true
      return
      
    else
      render :text => "error"
      return
    end
  end
  
  
  private
  
  def after_api_call
    logout_without_redirect!
  end
end
