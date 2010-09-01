class EventGroupsController < ApplicationController
  # GET /event_groups
  # GET /event_groups.xml
  def index
    @event_groups = EventGroup.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @event_groups }
    end
  end

  # GET /event_groups/1
  # GET /event_groups/1.xml
  def show
    @event_group = EventGroup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event_group }
    end
  end

  # GET /event_groups/new
  # GET /event_groups/new.xml
  def new
    @event_group = EventGroup.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event_group }
    end
  end

  # GET /event_groups/1/edit
  def edit
    @event_group = EventGroup.find(params[:id])
  end

  # POST /event_groups
  # POST /event_groups.xml
  def create
    @event_group = EventGroup.new(params[:event_group])

    respond_to do |format|
      if @event_group.save
        flash[:notice] = 'EventGroup was successfully created.'
        format.html { redirect_to(@event_group) }
        format.xml  { render :xml => @event_group, :status => :created, :location => @event_group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /event_groups/1
  # PUT /event_groups/1.xml
  def update
    @event_group = EventGroup.find(params[:id])

    respond_to do |format|
      if @event_group.update_attributes(params[:event_group])
        flash[:notice] = 'EventGroup was successfully updated.'
        format.html { redirect_to(@event_group) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /event_groups/1
  # DELETE /event_groups/1.xml
  def destroy
    @event_group = EventGroup.find(params[:id])
    @event_group.destroy

    respond_to do |format|
      format.html { redirect_to(event_groups_url) }
      format.xml  { head :ok }
    end
  end
end
