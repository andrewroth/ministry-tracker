class LinkBarController < ApplicationController
  unloadable
  
  skip_standard_login_stack :only => [:index, :widget, :iframe_widget]
  
  before_filter :setup_vars
  

  def index
    render :layout => false    
  end

  def widget
    render :layout => false
  end
  
  def iframe_widget
    render :layout => false
  end
  
  private
  
  def setup_vars
    @show_staff = false
    @page_wrapper_width = params[:page_wrapper_width] ? params[:page_wrapper_width] : "900px"
    @active_tab_id = params[:active_tab_id] ? params[:active_tab_id] : ""
    @base_url = base_url
  end
  
end
