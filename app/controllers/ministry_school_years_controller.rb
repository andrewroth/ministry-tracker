class MinistrySchoolYearsController < ApplicationController
  # GET /ministry_school_years
  # GET /ministry_school_years.xml
  def index
    @ministry_school_years = MinistrySchoolYear.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ministry_school_years }
    end
  end

  # GET /ministry_school_years/1
  # GET /ministry_school_years/1.xml
  def show
    @ministry_school_year = MinistrySchoolYear.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ministry_school_year }
    end
  end

  # GET /ministry_school_years/new
  # GET /ministry_school_years/new.xml
  def new
    @ministry_school_year = MinistrySchoolYear.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ministry_school_year }
    end
  end

  # GET /ministry_school_years/1/edit
  def edit
    @ministry_school_year = MinistrySchoolYear.find(params[:id])
  end

  # POST /ministry_school_years
  # POST /ministry_school_years.xml
  def create
    @ministry_school_year = MinistrySchoolYear.new(params[:ministry_school_year])

    respond_to do |format|
      if @ministry_school_year.save
        flash[:notice] = 'MinistrySchoolYear was successfully created.'
        format.html { redirect_to(@ministry_school_year) }
        format.xml  { render :xml => @ministry_school_year, :status => :created, :location => @ministry_school_year }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ministry_school_year.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ministry_school_years/1
  # PUT /ministry_school_years/1.xml
  def update
    @ministry_school_year = MinistrySchoolYear.find(params[:id])

    respond_to do |format|
      if @ministry_school_year.update_attributes(params[:ministry_school_year])
        flash[:notice] = 'MinistrySchoolYear was successfully updated.'
        format.html { redirect_to(@ministry_school_year) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ministry_school_year.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ministry_school_years/1
  # DELETE /ministry_school_years/1.xml
  def destroy
    @ministry_school_year = MinistrySchoolYear.find(params[:id])
    @ministry_school_year.destroy

    respond_to do |format|
      format.html { redirect_to(ministry_school_years_url) }
      format.xml  { head :ok }
    end
  end
end
