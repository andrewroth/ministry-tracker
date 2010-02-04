class AssignmentstatusesController < ApplicationController
  unloadable
  layout 'manage'

  # GET /assignmentstatuses
  # GET /assignmentstatuses.xml
  def index
    @assignmentstatuses = Assignmentstatus.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @assignmentstatuses }
    end
  end

  # GET /assignmentstatuses/1
  # GET /assignmentstatuses/1.xml
  def show
    @assignmentstatus = Assignmentstatus.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @assignmentstatus }
    end
  end

  # GET /assignmentstatuses/new
  # GET /assignmentstatuses/new.xml
  def new
    @assignmentstatus = Assignmentstatus.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @assignmentstatus }
    end
  end

  # GET /assignmentstatuses/1/edit
  def edit
    @assignmentstatus = Assignmentstatus.find(params[:id])
  end

  # POST /assignmentstatuses
  # POST /assignmentstatuses.xml
  def create
    @assignmentstatus = Assignmentstatus.new(params[:assignmentstatus])

    respond_to do |format|
      if @assignmentstatus.save
        flash[:notice] = 'Assignment status was successfully created.'
        format.html { redirect_to(@assignmentstatus) }
        format.xml  { render :xml => @assignmentstatus, :status => :created, :location => @assignmentstatus }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @assignmentstatus.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /assignmentstatuses/1
  # PUT /assignmentstatuses/1.xml
  def update
    @assignmentstatus = Assignmentstatus.find(params[:id])

    respond_to do |format|
      if @assignmentstatus.update_attributes(params[:assignmentstatus])
        flash[:notice] = 'Assignment status was successfully updated.'
        format.html { redirect_to(@assignmentstatus) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @assignmentstatus.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /assignmentstatuses/1
  # DELETE /assignmentstatuses/1.xml
  def destroy
    @assignmentstatus = Assignmentstatus.find(params[:id])
    @assignmentstatus.destroy

    unless @assignmentstatus.errors.empty?
      flash[:notice] = "WARNING: Couldn't delete assignment status because:"
      @assignmentstatus.errors.full_messages.each { |m| flash[:notice] << "<br/>" << m }
    end

    respond_to do |format|
      format.html { redirect_to(assignmentstatuses_url) }
      format.xml  { head :ok }
    end
  end
end
