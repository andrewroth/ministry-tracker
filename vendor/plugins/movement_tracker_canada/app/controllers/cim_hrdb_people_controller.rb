class CimHrdbPeopleController < ApplicationController
  unloadable
  layout 'manage'

  # GET /cim_hrdb_people
  # GET /cim_hrdb_people.xml
  def index
    @cim_hrdb_people = Person.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cim_hrdb_people }
    end
  end

  def search
    @query = params[:search][:query]

    @people = get_people_from_query(@query)

    respond_to do |format|
      format.js if request.xhr?
      format.html
    end
  end

  # GET /cim_hrdb_people/1
  # GET /cim_hrdb_people/1.xml
  def show
    @cim_hrdb_person = Person.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cim_hrdb_person }
    end
  end

  # GET /cim_hrdb_people/new
  # GET /cim_hrdb_people/new.xml
  def new
    @cim_hrdb_person = Person.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cim_hrdb_person }
    end
  end

  # GET /cim_hrdb_people/1/edit
  def edit
    @cim_hrdb_person = Person.find(params[:id])
    @cim_hrdb_assignments = Assignment.all(:conditions => {:person_id => @cim_hrdb_person.id})
    @cim_hrdb_person_years = CimHrdbPersonYear.all(:conditions => {:person_id => @cim_hrdb_person.id})
  end

  # POST /cim_hrdb_people
  # POST /cim_hrdb_people.xml
  def create
    @cim_hrdb_person = Person.new(params[:cim_hrdb_person])

    respond_to do |format|
      if @cim_hrdb_person.save
        flash[:notice] = 'Person was successfully created.'
        format.html { redirect_to(@cim_hrdb_person) }
        format.xml  { render :xml => @cim_hrdb_person, :status => :created, :location => @cim_hrdb_person }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cim_hrdb_person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cim_hrdb_people/1
  # PUT /cim_hrdb_people/1.xml
  def update
    @cim_hrdb_person = Person.find(params[:id])

    respond_to do |format|
      if @cim_hrdb_person.update_attributes(params[:cim_hrdb_person])
        flash[:notice] = 'Person was successfully updated.'
        format.html { redirect_to(@cim_hrdb_person) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cim_hrdb_person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cim_hrdb_people/1
  # DELETE /cim_hrdb_people/1.xml
  def destroy
    @cim_hrdb_person = Person.find(params[:id])
    @cim_hrdb_person.destroy

    respond_to do |format|
      format.html { redirect_to(cim_hrdb_people_url) }
      format.xml  { head :ok }
    end
  end


  private

  def get_people_from_query(search_query)
    if search_query then
      Person.all(:limit => User::MAX_SEARCH_RESULTS,
                 :conditions => ["concat(#{_(:first_name, :person)}, \" \", #{_(:last_name, :person)}) like ? " +
                                 "or #{_(:id, :person)} like ? ",
                                 "%#{search_query}%", "%#{search_query}%"])
    else
      nil
    end
  end

end
