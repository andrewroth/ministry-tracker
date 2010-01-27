class AccountadminAccesscategoriesController < ApplicationController
  unloadable
  layout 'manage'

  # GET /accountadmin_accesscategories
  # GET /accountadmin_accesscategories.xml
  def index
    @accountadmin_accesscategories = AccountadminAccesscategory.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accountadmin_accesscategories }
    end
  end

  # GET /accountadmin_accesscategories/1
  # GET /accountadmin_accesscategories/1.xml
  def show
    @accountadmin_accesscategory = AccountadminAccesscategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @accountadmin_accesscategory }
    end
  end

  # GET /accountadmin_accesscategories/new
  # GET /accountadmin_accesscategories/new.xml
  def new
    @accountadmin_accesscategory = AccountadminAccesscategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @accountadmin_accesscategory }
    end
  end

  # GET /accountadmin_accesscategories/1/edit
  def edit
    @accountadmin_accesscategory = AccountadminAccesscategory.find(params[:id])
  end

  # POST /accountadmin_accesscategories
  # POST /accountadmin_accesscategories.xml
  def create
    @accountadmin_accesscategory = AccountadminAccesscategory.new(params[:accountadmin_accesscategory])

    respond_to do |format|
      if @accountadmin_accesscategory.save
        flash[:notice] = 'AccountadminAccesscategory was successfully created.'
        format.html { redirect_to(@accountadmin_accesscategory) }
        format.xml  { render :xml => @accountadmin_accesscategory, :status => :created, :location => @accountadmin_accesscategory }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @accountadmin_accesscategory.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /accountadmin_accesscategories/1
  # PUT /accountadmin_accesscategories/1.xml
  def update
    @accountadmin_accesscategory = AccountadminAccesscategory.find(params[:id])

    respond_to do |format|
      if @accountadmin_accesscategory.update_attributes(params[:accountadmin_accesscategory])
        flash[:notice] = 'AccountadminAccesscategory was successfully updated.'
        format.html { redirect_to(@accountadmin_accesscategory) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @accountadmin_accesscategory.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /accountadmin_accesscategories/1
  # DELETE /accountadmin_accesscategories/1.xml
  def destroy
    @accountadmin_accesscategory = AccountadminAccesscategory.find(params[:id])
    @accountadmin_accesscategory.destroy

    respond_to do |format|
      format.html { redirect_to(accountadmin_accesscategories_url) }
      format.xml  { head :ok }
    end
  end
end
