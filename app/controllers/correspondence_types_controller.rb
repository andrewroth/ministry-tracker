class CorrespondenceTypesController < ApplicationController
  layout 'manage'
  
  # GET /correspondence_types
  # GET /correspondence_types.xml
  def index
    @correspondence_types = CorrespondenceType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @correspondence_types }
    end
  end

  # GET /correspondence_types/1
  # GET /correspondence_types/1.xml
  def show
    @correspondence_type = CorrespondenceType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @correspondence_type }
    end
  end

  # GET /correspondence_types/new
  # GET /correspondence_types/new.xml
  def new
    @correspondence_type = CorrespondenceType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @correspondence_type }
    end
  end

  # GET /correspondence_types/1/edit
  def edit
    @correspondence_type = CorrespondenceType.find(params[:id])
  end

  # POST /correspondence_types
  # POST /correspondence_types.xml
  def create
    @correspondence_type = CorrespondenceType.new(params[:correspondence_type])

    respond_to do |format|
      if @correspondence_type.save
        flash[:notice] = 'CorrespondenceType was successfully created.'
        format.html { redirect_to(@correspondence_type) }
        format.xml  { render :xml => @correspondence_type, :status => :created, :location => @correspondence_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @correspondence_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /correspondence_types/1
  # PUT /correspondence_types/1.xml
  def update
    @correspondence_type = CorrespondenceType.find(params[:id])

    respond_to do |format|
      if @correspondence_type.update_attributes(params[:correspondence_type])
        flash[:notice] = 'CorrespondenceType was successfully updated.'
        format.html { redirect_to(correspondence_types_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @correspondence_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /correspondence_types/1
  # DELETE /correspondence_types/1.xml
  def destroy
    @correspondence_type = CorrespondenceType.find(params[:id])
    @correspondence_type.destroy

    respond_to do |format|
      format.html { redirect_to(correspondence_types_url) }
      format.xml  { head :ok }
    end
  end
end
