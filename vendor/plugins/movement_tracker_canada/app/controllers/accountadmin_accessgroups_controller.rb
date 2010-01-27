class AccountadminAccessgroupsController < ApplicationController
  unloadable
  layout 'manage'

  # GET /accountadmin_accessgroups
  # GET /accountadmin_accessgroups.xml
  def index
    @accountadmin_accessgroups = AccountadminAccessgroup.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accountadmin_accessgroups }
    end
  end

  # GET /accountadmin_accessgroups/1
  # GET /accountadmin_accessgroups/1.xml
  def show
    @accountadmin_accessgroup = AccountadminAccessgroup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @accountadmin_accessgroup }
    end
  end

  # GET /accountadmin_accessgroups/new
  # GET /accountadmin_accessgroups/new.xml
  def new
    @accountadmin_accessgroup = AccountadminAccessgroup.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @accountadmin_accessgroup }
    end
  end

  # GET /accountadmin_accessgroups/1/edit
  def edit
    @accountadmin_accessgroup = AccountadminAccessgroup.find(params[:id])
  end

  # POST /accountadmin_accessgroups
  # POST /accountadmin_accessgroups.xml
  def create
    @accountadmin_accessgroup = AccountadminAccessgroup.new(params[:accountadmin_accessgroup])

    respond_to do |format|
      if @accountadmin_accessgroup.save
        flash[:notice] = 'AccountadminAccessgroup was successfully created.'
        format.html { redirect_to(@accountadmin_accessgroup) }
        format.xml  { render :xml => @accountadmin_accessgroup, :status => :created, :location => @accountadmin_accessgroup }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @accountadmin_accessgroup.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /accountadmin_accessgroups/1
  # PUT /accountadmin_accessgroups/1.xml
  def update
    @accountadmin_accessgroup = AccountadminAccessgroup.find(params[:id])

    respond_to do |format|
      if @accountadmin_accessgroup.update_attributes(params[:accountadmin_accessgroup])
        flash[:notice] = 'AccountadminAccessgroup was successfully updated.'
        format.html { redirect_to(@accountadmin_accessgroup) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @accountadmin_accessgroup.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /accountadmin_accessgroups/1
  # DELETE /accountadmin_accessgroups/1.xml
  def destroy
    @accountadmin_accessgroup = AccountadminAccessgroup.find(params[:id])
    @accountadmin_accessgroup.destroy

    respond_to do |format|
      format.html { redirect_to(accountadmin_accessgroups_url) }
      format.xml  { head :ok }
    end
  end
end
