class GlobalDashboardAccessesController < ApplicationController
  before_filter :ensure_admin

  # GET /global_dashboard_accesses
  # GET /global_dashboard_accesses.xml
  def index
    @global_dashboard_accesses = GlobalDashboardAccess.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @global_dashboard_accesses }
    end
  end

  # GET /global_dashboard_accesses/1
  # GET /global_dashboard_accesses/1.xml
  def show
    @global_dashboard_access = GlobalDashboardAccess.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @global_dashboard_access }
    end
  end

  # GET /global_dashboard_accesses/new
  # GET /global_dashboard_accesses/new.xml
  def new
    @global_dashboard_access = GlobalDashboardAccess.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @global_dashboard_access }
    end
  end

  # GET /global_dashboard_accesses/1/edit
  def edit
    @global_dashboard_access = GlobalDashboardAccess.find(params[:id])
  end

  # POST /global_dashboard_accesses
  # POST /global_dashboard_accesses.xml
  def create
    @global_dashboard_access = GlobalDashboardAccess.new(params[:global_dashboard_access])
    # try to find the user already
    u = User.find_by_guid(@global_dashboard_access.guid)
    unless u
      u = Person.create_new_cim_hrdb_account(@global_dashboard_access.guid, 
                                         @global_dashboard_access.fn, 
                                         @global_dashboard_access.ln, 
                                         @global_dashboard_access.email)
      p = u.person
      p.timetable
      mi = p.ministry_involvements.new
      mi.ministry = Ministry.find_by_name "CCCI Global Team"
      mi.ministry_role = StaffRole.find_by_name "International Staff"
      mi.save!
    end

    respond_to do |format|
      if @global_dashboard_access.save
        format.html { redirect_to(@global_dashboard_access, :notice => 'GlobalDashboardAccess was successfully created.') }
        format.xml  { render :xml => @global_dashboard_access, :status => :created, :location => @global_dashboard_access }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @global_dashboard_access.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /global_dashboard_accesses/1
  # PUT /global_dashboard_accesses/1.xml
  def update
    @global_dashboard_access = GlobalDashboardAccess.find(params[:id])

    respond_to do |format|
      if @global_dashboard_access.update_attributes(params[:global_dashboard_access])
        format.html { redirect_to(@global_dashboard_access, :notice => 'GlobalDashboardAccess was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @global_dashboard_access.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /global_dashboard_accesses/1
  # DELETE /global_dashboard_accesses/1.xml
  def destroy
    @global_dashboard_access = GlobalDashboardAccess.find(params[:id])
    @global_dashboard_access.destroy

    respond_to do |format|
      format.html { redirect_to(global_dashboard_accesses_url) }
      format.xml  { head :ok }
    end
  end

  protected

    def ensure_admin
      access_denied unless is_ministry_admin
    end

end
