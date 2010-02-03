class CimHrdbCampusesController < ApplicationController
  unloadable
  layout 'manage'

  # GET /campuses
  # GET /campuses.xml
  def index
    @campuses = Campus.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @campuses }
    end
  end

  # GET /campuses/1
  # GET /campuses/1.xml
  def show
    @campus = Campus.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @campus }
    end
  end

  # GET /campuses/new
  # GET /campuses/new.xml
  def new
    @campus = Campus.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @campus }
    end
  end

  # GET /campuses/1/edit
  def edit
    @campus = Campus.find(params[:id])
  end

  # POST /campuses
  # POST /campuses.xml
  def create
    @campus = Campus.new(params[:campus])

    respond_to do |format|
      if @campus.save
        flash[:notice] = 'Campus was successfully created.'
        format.html { redirect_to(cim_hrdb_campus_path(@campus)) }
        format.xml  { render :xml => @campus, :status => :created, :location => @campus }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @campus.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /campuses/1
  # PUT /campuses/1.xml
  def update
    @campus = Campus.find(params[:id])

    respond_to do |format|
      if @campus.update_attributes(params[:campus])
        flash[:notice] = 'Campus was successfully updated.'
        format.html { redirect_to(cim_hrdb_campus_path(@campus)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @campus.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /campuses/1
  # DELETE /campuses/1.xml
  def destroy
    @campus = Campus.find(params[:id])
    @campus.destroy

    respond_to do |format|
      format.html { redirect_to(cim_hrdb_campuses_url) }
      format.xml  { head :ok }
    end
  end
end
