class PermissionsController < ApplicationController
  layout 'manage'
  def index
    respond_to do |format|
      format.html
      format.js do 
        render :update do |page|
          page[:manage].replace_html :partial => 'index'
        end
      end
    end
  end
end