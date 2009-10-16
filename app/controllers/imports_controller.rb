# question: Seems to handle imports of a user list?

class ImportsController < ApplicationController
  before_filter :authorized?
  
  def new
    @import = Import.new
  end
  
  def create
    @import = @person.imports.new(params[:import])
    respond_to do |format|
      if @import.valid? && !params[:campus_id].blank?
        @import.save!
        @import.send_later(:process!, params[:campus_id], @ministry, @me)
      end
      # if @successful && @successful > 0
        flash[:notice] = "Your file has been queued for import. We'll shoot you an email as soon as it's done"
        # if @unsuccessful > 0
        #   flash[:warning] = "Failed to import #{@unsuccessful} #{@unsuccessful > 1 ? 'people' : 'person'}"
        # end
        format.html { redirect_to(directory_people_path(:format => :html)) }
        format.xml  { render :xml => @import, :status => :created, :location => @import  }
      # else
      #   flash[:warning] = 'Import failed. Check to make sure you header column names match the names on the right exactly.'
      #   @import = Import.new
      #   format.html { render :action => :new }
      #   format.xml  { render :xml => @import.errors, :status => :unprocessable_entity }
      # end
    end
  end
end
