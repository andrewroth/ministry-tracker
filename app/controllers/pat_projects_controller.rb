class PatProjectsController < ApplicationController
  # GET /pat_projects
  # GET /pat_projects.xml
  def index
    @pat_projects = Pat::Project.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pat_projects }
    end
  end

  # GET /pat_projects/1
  # GET /pat_projects/1.xml
  def show
    @pat_project = Pat::Project.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pat_project }
    end
  end

  # GET /pat_projects/new
  # GET /pat_projects/new.xml
  def new
    @pat_project = Pat::Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pat_project }
    end
  end

  # GET /pat_projects/1/edit
  def edit
    @pat_project = Pat::Project.find(params[:id])
  end

  # POST /pat_projects
  # POST /pat_projects.xml
  def create
    @pat_project = Pat::Project.new(params[:pat_project])

    respond_to do |format|
      if @pat_project.save
        format.html { redirect_to(@pat_project, :notice => 'Pat::Project was successfully created.') }
        format.xml  { render :xml => @pat_project, :status => :created, :location => @pat_project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pat_project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pat_projects/1
  # PUT /pat_projects/1.xml
  def update
    @pat_project = Pat::Project.find(params[:id])

    respond_to do |format|
      if @pat_project.update_attributes(params[:pat_project])
        format.html { redirect_to(pat_projects_path, :notice => 'Project was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pat_project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pat_projects/1
  # DELETE /pat_projects/1.xml
  def destroy
    @pat_project = Pat::Project.find(params[:id])
    @pat_project.destroy

    respond_to do |format|
      format.html { redirect_to(pat_projects_url) }
      format.xml  { head :ok }
    end
  end
end
