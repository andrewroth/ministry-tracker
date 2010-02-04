class CimHrdbCountriesController < ApplicationController
  unloadable
  layout 'manage'

  # GET /countries
  # GET /countries.xml
  def index
    @countries = Country.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @countries }
    end
  end

  # GET /countries/1
  # GET /countries/1.xml
  def show
    @country = Country.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @country }
    end
  end

  # GET /countries/new
  # GET /countries/new.xml
  def new
    @country = Country.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @country }
    end
  end

  # GET /countries/1/edit
  def edit
    @country = Country.find(params[:id])
  end

  # POST /countries
  # POST /countries.xml
  def create
    @country = Country.new(params[:country])

    respond_to do |format|
      if @country.save
        flash[:notice] = 'Country was successfully created.'
        format.html { redirect_to(cim_hrdb_country_path(@country)) }
        format.xml  { render :xml => @country, :status => :created, :location => @country }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @country.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /countries/1
  # PUT /countries/1.xml
  def update
    @country = Country.find(params[:id])

    respond_to do |format|
      if @country.update_attributes(params[:country])
        flash[:notice] = 'Country was successfully updated.'
        format.html { redirect_to(cim_hrdb_country_path(@country)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @country.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /countries/1
  # DELETE /countries/1.xml
  def destroy
    @country = Country.find(params[:id])
    @country.destroy

    unless @country.errors.empty?
      flash[:notice] = "WARNING: Couldn't delete country because:"
      @country.errors.full_messages.each { |m| flash[:notice] << "<br/>" << m }
    end

    respond_to do |format|
      format.html { redirect_to(cim_hrdb_countries_url) }
      format.xml  { head :ok }
    end
  end
end
