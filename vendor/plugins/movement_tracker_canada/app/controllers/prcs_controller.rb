class PrcsController < ApplicationController
  unloadable

  # GET /prcs
  # GET /prcs.xml
  def index
    cur_month = "#{Date::MONTHNAMES[Time.now.month()]} #{Time.now.year()}"
    cur_month_id = Month.find_semester_id(cur_month)
    
    semester_id = cur_month_id    
    
    setup_for_index(semester_id)

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
  
    cur_month = "#{Date::MONTHNAMES[Time.now.month()]} #{Time.now.year()}"
    cur_month_id = Month.find_semester_id(cur_month)
    
    semester_id = cur_month_id   
    campus_id = get_ministry.unique_campuses.first.id   #NEW!    
    date = Date.today()

    setup_for_record(semester_id, campus_id, date)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @prc }
    end
  end

  # GET /prcs/1/edit
  def edit
    @prc = Prc.find(params[:id])
    setup_campuses_and_semesters

    respond_to do |format|
      format.html # edit.html.erb
      format.xml  { render :xml => @prc }
    end
  end
  
  # POST /prcs
  # POST /prcs.xml
  def create
    create_or_update
  end

  # PUT /prcs/1
  # PUT /prcs/1.xml
  def update
    create_or_update
  end

  # DELETE /prcs/1
  # DELETE /prcs/1.xml
  def destroy
    @prc = Prc.find(params[:id])
    @prc.destroy

    unless @prc.errors.empty?
      flash[:notice] = "WARNING: Couldn't delete indicated decision report because:"
      @prc.errors.full_messages.each { |m| flash[:notice] << "<br/>" << m }
    end

    respond_to do |format|
      format.html { redirect_to(prcs_url) }
      format.xml  { head :ok }
    end
  end
  

  def select_prc_report
    setup_for_record(params['semester_id'], params['campus_id'], params['date'])
  
    respond_to do |format|
      format.js
    end
  end
  
  def refresh_prc_index
    setup_for_index(params['semester_id'])
  
    respond_to do |format|
      format.js
    end
  end
  
  
  protected
  
  def create_or_update
    @prc = Prc.find(:first, :conditions => { :prc_id => params[:prc][:id] } )
                                           #  :semester_id => params[:prc][:semester_id], 
                                           #  :campus_id => params[:prc][:campus_id], 
                                           #  :prc_date => params[:prc][:date] })  
  
    if @prc
      success_update = true if @prc.update_attributes(params[:prc])
    else
      success_update = true if @prc = Prc.new(params[:prc])
    end
  
    respond_to do |format|
      if success_update
        @prc.save!
        flash[:notice] = 'Your indicated decision report was successfully submitted.'
        format.html { redirect_to(url_for(:controller => :prcs, :action => :index)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @prc.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def setup_campuses_and_semesters()
    @semesters = Semester.all(:order => :semester_startDate)  

    @campuses = @my.campuses_under_my_ministries_with_children(::MinistryRole::ministry_roles_that_grant_access("prcs", "new"))
    
  end
  
  def setup_for_record(semester_id, campus_id, date)
    
    @prc = Prc.find(:first, :conditions => { :semester_id => semester_id, :campus_id => campus_id, :prc_date => date })  
    @prc ||= Prc.new
          
    @prc.semester_id = semester_id
    @prc.campus_id = campus_id
    @prc.prc_date = date
    
    setup_campuses_and_semesters
    
    @methods = Prcmethod.all()
    
  end 
  
  def setup_for_index(semester_id)
    
    @campuses = @my.campuses_under_my_ministries_with_children(::MinistryRole::ministry_roles_that_grant_access("prcs", "new"))
    campus_id = @campuses.first().id
    
    @prcs = Prc.find_all_by_semester_id_and_campus_id(semester_id, campus_id)  
    @prcs ||= Prc.all
    
    @semesters = Semester.all(:order => :semester_startDate)  

    
    @methods = Prcmethod.all()
    
  end  
  
end
