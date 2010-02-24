class CimHrdbPersonYearsController < ApplicationController
  unloadable
  layout 'manage'

  # GET /cim_hrdb_person_years
  # GET /cim_hrdb_person_years.xml
  def index
    @cim_hrdb_person_years = CimHrdbPersonYear.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cim_hrdb_person_years }
    end
  end

  # GET /cim_hrdb_person_years/1
  # GET /cim_hrdb_person_years/1.xml
  def show
    @cim_hrdb_person_year = CimHrdbPersonYear.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cim_hrdb_person_year }
    end
  end

  # GET /cim_hrdb_person_years/new
  # GET /cim_hrdb_person_years/new.xml
  def new
    @cim_hrdb_person = Person.find(params[:cim_hrdb_person_id])
    @cim_hrdb_person_year = @cim_hrdb_person.cim_hrdb_person_years.build(:person_id => params[:cim_hrdb_person_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cim_hrdb_person_year }
    end
  end

  # GET /cim_hrdb_person_years/1/edit
  def edit
    @cim_hrdb_person_year = CimHrdbPersonYear.find(params[:id])
    @cim_hrdb_person = @cim_hrdb_person_year.person
  end

  # POST /cim_hrdb_person_years
  # POST /cim_hrdb_person_years.xml
  def create
    @cim_hrdb_person_year = CimHrdbPersonYear.new(params[:cim_hrdb_person_year])
    @cim_hrdb_person_year.person_id = params[:cim_hrdb_person_id]

    respond_to do |format|
      if @cim_hrdb_person_year.save
        flash[:notice] = 'Year in school was successfully created.'
        format.html { redirect_to(edit_cim_hrdb_person_path(@cim_hrdb_person_year.person.person_id)) }
        format.xml  { render :xml => @cim_hrdb_person_year, :status => :created, :location => @cim_hrdb_person_year }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cim_hrdb_person_year.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cim_hrdb_person_years/1
  # PUT /cim_hrdb_person_years/1.xml
  def update
    @cim_hrdb_person_year = CimHrdbPersonYear.find(params[:id])
    @cim_hrdb_person_year.year_id = params[:cim_hrdb_person_year][:year_id]
    @cim_hrdb_person_year.grad_date = params[:cim_hrdb_person_year][:grad_date]

    respond_to do |format|
      if @cim_hrdb_person_year.save
        flash[:notice] = 'Year in school was successfully updated.'
        format.html { redirect_to(edit_cim_hrdb_person_path(@cim_hrdb_person_year.person.person_id)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cim_hrdb_person_year.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cim_hrdb_person_years/1
  # DELETE /cim_hrdb_person_years/1.xml
  def destroy
    @cim_hrdb_person_year = CimHrdbPersonYear.find(params[:id])
    @cim_hrdb_person = @cim_hrdb_person_year.person
    @cim_hrdb_person_year.destroy

    respond_to do |format|
      format.html { redirect_to(edit_cim_hrdb_person_path(@cim_hrdb_person.person_id)) }
      format.xml  { head :ok }
    end
  end
end
