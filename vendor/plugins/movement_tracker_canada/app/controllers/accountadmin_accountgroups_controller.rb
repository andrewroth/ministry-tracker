class AccountadminAccountgroupsController < ApplicationController
  unloadable
  layout 'manage'

  # GET /accountadmin_accountgroups
  # GET /accountadmin_accountgroups.xml
  def index
    @accountadmin_accountgroups = AccountadminAccountgroup.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accountadmin_accountgroups }
    end
  end

  # GET /accountadmin_accountgroups/1
  # GET /accountadmin_accountgroups/1.xml
  def show
    @accountadmin_accountgroup = AccountadminAccountgroup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @accountadmin_accountgroup }
    end
  end

  # GET /accountadmin_accountgroups/new
  # GET /accountadmin_accountgroups/new.xml
  def new
    @accountadmin_accountgroup = AccountadminAccountgroup.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @accountadmin_accountgroup }
    end
  end

  # GET /accountadmin_accountgroups/1/edit
  def edit
    @accountadmin_accountgroup = AccountadminAccountgroup.find(params[:id])
  end

  # POST /accountadmin_accountgroups
  # POST /accountadmin_accountgroups.xml
  def create
    @accountadmin_accountgroup = AccountadminAccountgroup.new(params[:accountadmin_accountgroup])

    respond_to do |format|
      if @accountadmin_accountgroup.save
        flash[:notice] = 'Account group was successfully created.'
        format.html { redirect_to(@accountadmin_accountgroup) }
        format.xml  { render :xml => @accountadmin_accountgroup, :status => :created, :location => @accountadmin_accountgroup }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @accountadmin_accountgroup.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /accountadmin_accountgroups/1
  # PUT /accountadmin_accountgroups/1.xml
  def update
    @accountadmin_accountgroup = AccountadminAccountgroup.find(params[:id])

    respond_to do |format|
      if @accountadmin_accountgroup.update_attributes(params[:accountadmin_accountgroup])
        flash[:notice] = 'Account group was successfully updated.'
        format.html { redirect_to(@accountadmin_accountgroup) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @accountadmin_accountgroup.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /accountadmin_accountgroups/1
  # DELETE /accountadmin_accountgroups/1.xml
  def destroy
    @accountadmin_accountgroup = AccountadminAccountgroup.find(params[:id])
    @accountadmin_accountgroup.destroy

    flash[:notice] = "WARNING: Couldn't delete account group because it's " + @accountadmin_accountgroup.errors.first.to_s unless @accountadmin_accountgroup.errors.empty?

    respond_to do |format|
      format.html { redirect_to(accountadmin_accountgroups_url) }
      format.xml  { head :ok }
    end
  end
end
