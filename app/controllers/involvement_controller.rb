# Looks up what ppl have been involved in (eg summer projects, conferences etc),
# a read-only view...

class InvolvementController < ApplicationController
  layout 'people'
  
  def index
    setup_involvement_vars
  end

end
