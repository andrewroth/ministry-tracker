class GlobalCountriesController < ApplicationController
  # GET /global_countries
  # GET /global_countries.xml
  def index
    @global_countries = GlobalCountry.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @global_countries }
    end
  end

  # GET /global_countries/1
  # GET /global_countries/1.xml
  def show
    @global_country = GlobalCountry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @global_country }
    end
  end

  # GET /global_countries/new
  # GET /global_countries/new.xml
  def new
    @global_country = GlobalCountry.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @global_country }
    end
  end

  # GET /global_countries/1/edit
  def edit
    @global_country = GlobalCountry.find(params[:id])
  end

  # POST /global_countries
  # POST /global_countries.xml
  def create
    @global_country = GlobalCountry.new(params[:global_country])

    respond_to do |format|
      if @global_country.save
        format.html { redirect_to(@global_country, :notice => 'GlobalCountry was successfully created.') }
        format.xml  { render :xml => @global_country, :status => :created, :location => @global_country }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @global_country.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /global_countries/1
  # PUT /global_countries/1.xml
  def update
    @global_country = GlobalCountry.find(params[:id])

    respond_to do |format|
      if @global_country.update_attributes(params[:global_country])
        format.html { redirect_to(@global_country, :notice => 'GlobalCountry was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @global_country.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /global_countries/1
  # DELETE /global_countries/1.xml
  def destroy
    @global_country = GlobalCountry.find(params[:id])
    @global_country.destroy

    respond_to do |format|
      format.html { redirect_to(global_countries_url) }
      format.xml  { head :ok }
    end
  end
end
