class ManageController < ApplicationController
  layout 'manage'
  
  def index
    setup_ministries
  end
end
