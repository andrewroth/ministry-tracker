class GlobalAreasController < ApplicationController
  # GET /global_areas
  # GET /global_areas.xml
  def index
    @global_areas = GlobalArea.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @global_areas }
    end
  end

  # GET /global_areas/1
  # GET /global_areas/1.xml
  def show
    @global_area = GlobalArea.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @global_area }
    end
  end

  # GET /global_areas/new
  # GET /global_areas/new.xml
  def new
    @global_area = GlobalArea.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @global_area }
    end
  end

  # GET /global_areas/1/edit
  def edit
    @global_area = GlobalArea.find(params[:id])
  end

  # POST /global_areas
  # POST /global_areas.xml
  def create
    @global_area = GlobalArea.new(params[:global_area])

    respond_to do |format|
      if @global_area.save
        format.html { redirect_to(@global_area, :notice => 'GlobalArea was successfully created.') }
        format.xml  { render :xml => @global_area, :status => :created, :location => @global_area }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @global_area.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /global_areas/1
  # PUT /global_areas/1.xml
  def update
    @global_area = GlobalArea.find(params[:id])

    respond_to do |format|
      if @global_area.update_attributes(params[:global_area])
        format.html { redirect_to(@global_area, :notice => 'GlobalArea was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @global_area.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /global_areas/1
  # DELETE /global_areas/1.xml
  def destroy
    @global_area = GlobalArea.find(params[:id])
    @global_area.destroy

    respond_to do |format|
      format.html { redirect_to(global_areas_url) }
      format.xml  { head :ok }
    end
  end
end
