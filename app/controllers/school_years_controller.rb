# CRUD for school years.
#
# Question: School years are definable by ministry or campus?
class SchoolYearsController < ApplicationController
  # GET /school_years
  # GET /school_years.xml
  def index
    @school_years = SchoolYear.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @school_years }
    end
  end

  # GET /school_years/new
  # GET /school_years/new.xml
  def new
    @school_year = SchoolYear.new

    respond_to do |format|
      format.js # new.html.erb
      format.xml  { render :xml => @school_year }
    end
  end

  # GET /school_years/1/edit
  def edit
    @school_year = SchoolYear.find(params[:id])
  end

  # POST /school_years
  # POST /school_years.xml
  def create
    @school_year = SchoolYear.new(params[:school_year])

    respond_to do |format|
      if @school_year.save
        format.js
        format.xml  { render :xml => @school_year, :status => :created, :location => @school_year }
      else
        format.js { render :action => "new" }
        format.xml  { render :xml => @school_year.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /school_years/1
  # PUT /school_years/1.xml
  def update
    @school_year = SchoolYear.find(params[:id])

    respond_to do |format|
      if @school_year.update_attributes(params[:school_year])
        format.js
        format.xml  { head :ok }
      else
        format.js { render :action => "edit" }
        format.xml  { render :xml => @school_year.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /school_years/1
  # DELETE /school_years/1.xml
  def destroy
    @school_year = SchoolYear.find(params[:id])
    @school_year.destroy

    respond_to do |format|
      format.js
      format.xml  { head :ok }
    end
  end
  
  def reorder
    SchoolYear.find(:all).each do |school_year|
      school_year.position = params['school_years'].index(school_year.id.to_s) + 1
      school_year.save
    end
    render :nothing => true
  end
  
  protected 
    def authorization_filter
      authorized?(:edit, :ministry_roles)
    end
end
