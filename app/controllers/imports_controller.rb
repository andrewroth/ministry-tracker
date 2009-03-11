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
        @successful, @unsuccessful = @import.process!(params[:campus_id], @ministry)
      end
      if @successful && @successful > 0
        flash[:notice] = "Successfully imported #{@successful} #{@successful > 1 ? 'people' : 'person'}"
        if @unsuccessful > 0
          flash[:warning] = "Failed to import #{@unsuccessful} #{@unsuccessful > 1 ? 'people' : 'person'}"
        end
        format.html { redirect_to(directory_people_path) }
        format.xml  { render :xml => @import, :status => :created, :location => @import  }
      else
        flash[:warning] = 'Import failed. Check to make sure you header column names match the names on the right exactly.'
        @import = Import.new
        format.html { render :action => :new }
        format.xml  { render :xml => @import.errors, :status => :unprocessable_entity }
      end
    end
  end
end
