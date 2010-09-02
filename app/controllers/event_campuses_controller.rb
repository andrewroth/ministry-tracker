class EventCampusesController < ApplicationController
  # GET /event_campuses
  # GET /event_campuses.xml
  def index
    @event_campuses = EventCampus.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @event_campuses }
    end
  end

  # GET /event_campuses/1
  # GET /event_campuses/1.xml
  def show
    @event_campus = EventCampus.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event_campus }
    end
  end

  # GET /event_campuses/new
  # GET /event_campuses/new.xml
  def new
    @event_campus = EventCampus.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event_campus }
    end
  end

  # GET /event_campuses/1/edit
  def edit
    @event_campus = EventCampus.find(params[:id])
  end

  # POST /event_campuses
  # POST /event_campuses.xml
  def create
    @event_campus = EventCampus.new(params[:event_campus])

    respond_to do |format|
      if @event_campus.save
        flash[:notice] = 'EventCampus was successfully created.'
        format.html { redirect_to(@event_campus) }
        format.xml  { render :xml => @event_campus, :status => :created, :location => @event_campus }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event_campus.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /event_campuses/1
  # PUT /event_campuses/1.xml
  def update
    @event_campus = EventCampus.find(params[:id])

    respond_to do |format|
      if @event_campus.update_attributes(params[:event_campus])
        flash[:notice] = 'EventCampus was successfully updated.'
        format.html { redirect_to(@event_campus) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event_campus.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /event_campuses/1
  # DELETE /event_campuses/1.xml
  def destroy
    @event_campus = EventCampus.find(params[:id])
    @event_campus.destroy

    respond_to do |format|
      format.html { redirect_to(event_campuses_url) }
      format.xml  { head :ok }
    end
  end
end
