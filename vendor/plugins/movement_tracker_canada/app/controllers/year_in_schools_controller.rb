class YearInSchoolsController < ApplicationController
  unloadable
  layout 'manage'

  # GET /year_in_schools
  # GET /year_in_schools.xml
  def index
    @year_in_schools = YearInSchool.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @year_in_schools }
    end
  end

  # GET /year_in_schools/1
  # GET /year_in_schools/1.xml
  def show
    @year_in_school = YearInSchool.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @year_in_school }
    end
  end

  # GET /year_in_schools/new
  # GET /year_in_schools/new.xml
  def new
    @year_in_school = YearInSchool.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @year_in_school }
    end
  end

  # GET /year_in_schools/1/edit
  def edit
    @year_in_school = YearInSchool.find(params[:id])
  end

  # POST /year_in_schools
  # POST /year_in_schools.xml
  def create
    @year_in_school = YearInSchool.new(params[:year_in_school])

    respond_to do |format|
      if @year_in_school.save
        flash[:notice] = 'Year in School was successfully created.'
        format.html { redirect_to(@year_in_school) }
        format.xml  { render :xml => @year_in_school, :status => :created, :location => @year_in_school }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @year_in_school.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /year_in_schools/1
  # PUT /year_in_schools/1.xml
  def update
    @year_in_school = YearInSchool.find(params[:id])

    respond_to do |format|
      if @year_in_school.update_attributes(params[:year_in_school])
        flash[:notice] = 'Year in School was successfully updated.'
        format.html { redirect_to(@year_in_school) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @year_in_school.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /year_in_schools/1
  # DELETE /year_in_schools/1.xml
  def destroy
    @year_in_school = YearInSchool.find(params[:id])
    @year_in_school.destroy

    respond_to do |format|
      format.html { redirect_to(year_in_schools_url) }
      format.xml  { head :ok }
    end
  end
end
