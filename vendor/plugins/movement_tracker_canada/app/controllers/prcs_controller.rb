class PrcsController < ApplicationController
  unloadable

  # GET /prcs
  # GET /prcs.xml
  def index
    @prcs = Prc.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @prcs }
    end
  end

  # GET /prcs/1
  # GET /prcs/1.xml
  def show
    @prc = Prc.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @prc }
    end
  end

  # GET /prcs/new
  # GET /prcs/new.xml
  def new
    @prc = Prc.new

    cur_month = "#{Date::MONTHNAMES[Time.now.month()]} #{Time.now.year()}"
    cur_month_id = Month.find_semester_id(cur_month)
    @prc.semester_id = cur_month_id

    @semesters = Semester.find_semesters(cur_month_id)

    @campuses = @my.campuses_under_my_ministries_with_children(::MinistryRole::ministry_roles_that_grant_access("prcs", "new"))
    @prc.campus_id = get_ministry.unique_campuses.first.id

    @methods = Prcmethod.find_methods()

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @prc }
    end
  end

  # GET /prcs/1/edit
  def edit
    @prc = Prc.find(params[:id])
  end

  # POST /prcs
  # POST /prcs.xml
  def create

#    staff_id = @person.cim_hrdb_staff.id
#    @prc = Prc.find(:first, :conditions => { :week_id => params[:prc][:week_id], :staff_id => staff_id, :campus_id => params[:prc][:campus_id] })
#
#    if @prc
#      @prc.update_attributes(params[:prc])
#      notice = 'Your weekly numbers were successfully re-submitted.'
#    else
#      @prc = Prc.new(params[:prc])
#      @prc.staff_id = @person.cim_hrdb_staff.id
#      notice = 'Your weekly numbers were successfully submitted.'
#    end

    respond_to do |format|
      if @prc.save
        flash[:notice] = notice
        format.html { redirect_to(url_for(:controller => :stats, :action => :index)) }
        format.xml  { render :xml => @prc, :status => :created, :location => @prc }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @prc.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /prcs/1
  # PUT /prcs/1.xml
  def update
    @prc = Prc.find(params[:id])

    respond_to do |format|
      if @prc.update_attributes(params[:prc])
        flash[:notice] = 'Your weekly numbers were successfully submitted.'
        format.html { redirect_to(url_for(:controller => :stats, :action => :index)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @prc.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /prcs/1
  # DELETE /prcs/1.xml
  def destroy
    @prc = Prc.find(params[:id])
    @prc.destroy

    unless @prc.errors.empty?
      flash[:notice] = "WARNING: Couldn't delete weekly numbers because:"
      @prc.errors.full_messages.each { |m| flash[:notice] << "<br/>" << m }
    end

    respond_to do |format|
      format.html { redirect_to(prcs_url) }
      format.xml  { head :ok }
    end
  end
end
