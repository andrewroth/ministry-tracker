class CimRegEventsController < ApplicationController
  unloadable
  layout 'manage'

  # GET /cim_reg_events/1
  # GET /cim_reg_events/1.xml
  def show
    @cim_reg_event = CimRegEvent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cim_reg_event }
    end
  end

  # GET /cim_reg_events/new
  # GET /cim_reg_events/new.xml
  def new
    @cim_reg_event = CimRegEvent.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cim_reg_event }
    end
  end

  # GET /cim_reg_events/1/edit
  def edit
    @cim_reg_event = CimRegEvent.find(params[:id])
  end

  # POST /cim_reg_events
  # POST /cim_reg_events.xml
  def create
    @cim_reg_event = CimRegEvent.new(params[:cim_reg_event])

    respond_to do |format|
      if @cim_reg_event.save
        flash[:notice] = 'cim_reg_event was successfully created.'
        format.html { redirect_to(cim_reg_event_path(@cim_reg_event)) }
        format.xml  { render :xml => @cim_reg_event, :status => :created, :location => @cim_reg_event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cim_reg_event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cim_reg_events/1
  # PUT /cim_reg_events/1.xml
  def update
    @cim_reg_event = CimRegEvent.find(params[:id])

    respond_to do |format|
      if @cim_reg_event.update_attributes(params[:cim_reg_event])
        flash[:notice] = 'cim_reg_event was successfully updated.'
        format.html { redirect_to(cim_reg_event_path(@cim_reg_event)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cim_reg_event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cim_reg_events/1
  # DELETE /cim_reg_events/1.xml
  def destroy
    @cim_reg_event = cim_reg_event.find(params[:id])
    @cim_reg_event.destroy

    unless @cim_reg_event.errors.empty?
      flash[:notice] = "WARNING: Couldn't delete cim_reg_event because:"
      @cim_reg_event.errors.full_messages.each { |m| flash[:notice] << "<br/>" << m }
    end

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end
end
