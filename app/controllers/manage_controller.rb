# Brings you to main management screen.
# Displays all the options for managing a ministry:
# * group management
# * role management

class ManageController < ApplicationController
  layout 'manage'
  
  def index
    setup_ministries
  end
end
