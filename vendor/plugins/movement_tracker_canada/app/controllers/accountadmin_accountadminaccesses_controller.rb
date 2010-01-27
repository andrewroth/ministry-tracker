class AccountadminAccountadminaccessesController < ApplicationController
  unloadable
  layout 'manage'

  # GET /accountadmin_accountadminaccesses
  # GET /accountadmin_accountadminaccesses.xml
  def index
    @accountadmin_accountadminaccesses = AccountadminAccountadminaccess.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accountadmin_accountadminaccesses }
    end
  end

  # GET /accountadmin_accountadminaccesses/1
  # GET /accountadmin_accountadminaccesses/1.xml
  def show
    @accountadmin_accountadminaccess = AccountadminAccountadminaccess.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @accountadmin_accountadminaccess }
    end
  end

  # GET /accountadmin_accountadminaccesses/new
  # GET /accountadmin_accountadminaccesses/new.xml
  def new
    @accountadmin_accountadminaccess = AccountadminAccountadminaccess.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @accountadmin_accountadminaccess }
    end
  end

  # GET /accountadmin_accountadminaccesses/1/edit
  def edit
    @accountadmin_accountadminaccess = AccountadminAccountadminaccess.find(params[:id])
  end

  # POST /accountadmin_accountadminaccesses
  # POST /accountadmin_accountadminaccesses.xml
  def create
    @accountadmin_accountadminaccess = AccountadminAccountadminaccess.new(params[:accountadmin_adminaccess])

    respond_to do |format|
      if @accountadmin_accountadminaccess.save
        flash[:notice] = 'AccountadminAccountadminaccess was successfully created.'
        format.html { redirect_to(@accountadmin_accountadminaccess) }
        format.xml  { render :xml => @accountadmin_accountadminaccess, :status => :created, :location => @accountadmin_accountadminaccess }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @accountadmin_accountadminaccess.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /accountadmin_accountadminaccesses/1
  # PUT /accountadmin_accountadminaccesses/1.xml
  def update
    @accountadmin_accountadminaccess = AccountadminAccountadminaccess.find(params[:id])

    respond_to do |format|
      if @accountadmin_accountadminaccess.update_attributes(params[:accountadmin_adminaccess])
        flash[:notice] = 'AccountadminAccountadminaccess was successfully updated.'
        format.html { redirect_to(@accountadmin_accountadminaccess) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @accountadmin_accountadminaccess.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /accountadmin_accountadminaccesses/1
  # DELETE /accountadmin_accountadminaccesses/1.xml
  def destroy
    @accountadmin_accountadminaccess = AccountadminAccountadminaccess.find(params[:id])
    @accountadmin_accountadminaccess.destroy

    respond_to do |format|
      format.html { redirect_to(accountadmin_accountadminaccesses_url) }
      format.xml  { head :ok }
    end
  end
end
