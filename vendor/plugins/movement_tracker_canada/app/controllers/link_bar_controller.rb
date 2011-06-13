class LinkBarController < ApplicationController
  unloadable
  
  skip_standard_login_stack :only => [:widget]

  def widget
    @show_staff = false
    @page_wrapper_width = params[:page_wrapper_width] if params[:page_wrapper_width]
    @active_tab_id = params[:active_tab_id] ? params[:active_tab_id] : ""
    @base_url = base_url
    
    render :layout => false
  end

end
