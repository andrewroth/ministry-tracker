class CimHrdbAssignmentsController < ApplicationController
  unloadable
  layout 'manage'

  # GET /cim_hrdb_people/1/cim_hrdb_people/1/cim_hrdb_assignments
  # GET /cim_hrdb_people/1/cim_hrdb_assignments.xml
  def index
    @assignments = Assignment.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @assignments }
    end
  end

  # GET /cim_hrdb_people/1/cim_hrdb_assignments/1
  # GET /cim_hrdb_people/1/cim_hrdb_assignments/1.xml
  def show
    @assignment = Assignment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @assignment }
    end
  end

  # GET /cim_hrdb_people/1/cim_hrdb_assignments/new
  # GET /cim_hrdb_people/1/cim_hrdb_assignments/new.xml
  def new
    @cim_hrdb_person = Person.find(params[:cim_hrdb_person_id])
    @cim_hrdb_assignment = @cim_hrdb_person.assignments.build(:person_id => params[:cim_hrdb_person_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @assignment }
    end
  end

  # GET /cim_hrdb_people/1/cim_hrdb_assignments/1/edit
  def edit
    @cim_hrdb_assignment = Assignment.find(params[:id])
    @cim_hrdb_person = @cim_hrdb_assignment.person
  end

  # POST /cim_hrdb_people/1/cim_hrdb_assignments
  # POST /cim_hrdb_people/1/cim_hrdb_assignments.xml
  def create
    @cim_hrdb_assignment = Assignment.new(params[:assignment])
    @cim_hrdb_assignment.person_id = params[:cim_hrdb_person_id]

    respond_to do |format|
      if @cim_hrdb_assignment.save
        flash[:notice] = 'Assignment was successfully created.'
        format.html { redirect_to(edit_cim_hrdb_person_path(@cim_hrdb_assignment.person)) }
        format.xml  { render :xml => @cim_hrdb_assignment, :status => :created, :location => @cim_hrdb_assignment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cim_hrdb_assignment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cim_hrdb_people/1/cim_hrdb_assignments/1
  # PUT /cim_hrdb_people/1/cim_hrdb_assignments/1.xml
  def update
    @assignment = Assignment.find(params[:id])

    respond_to do |format|
      if @assignment.update_attributes(params[:assignment])
        flash[:notice] = 'Assignment was successfully updated.'
        format.html { redirect_to(edit_cim_hrdb_person_path(@assignment.person)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @assignment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cim_hrdb_people/1/cim_hrdb_assignments/1
  # DELETE /cim_hrdb_people/1/cim_hrdb_assignments/1.xml
  def destroy
    @assignment = Assignment.find(params[:id])
    @cim_hrdb_person = @assignment.person
    @assignment.destroy

    respond_to do |format|
      format.html { redirect_to(edit_cim_hrdb_person_path(@cim_hrdb_person)) }
      format.xml  { head :ok }
    end
  end

end
