# Seems to handle the registering of users as a developer, which apparently
# gives them added benefits
class DevelopersController < ApplicationController
  # GET /developers
  # GET /developers.xml
  def index
    @developers = User.find(:all, :conditions => {_(:developer, :user) => true})

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @developers }
    end
  end

  # POST /developers
  # POST /developers.xml
  def create
    @user = User.find(:first, :conditions => {_(:username, :user) => params[:email]})
    respond_to do |format|
      if @user && !@user.developer?
        @user.update_attribute(:developer, true)
        # format.xml  { render :xml => @user, :status => :created, :location => @user }
        format.js
      else
        # format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
        format.js {render :nothing => true}
      end
    end
  end

  # DELETE /developers/1
  # DELETE /developers/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.update_attribute(:developer, false)

    respond_to do |format|
      format.js
      format.xml  { head :ok }
    end
  end
end
