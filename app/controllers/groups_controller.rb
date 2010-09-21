# Groups associated with an individual
# delete candidate: def find_times is the method for common times but may no
# no longer being used, but is handled in timetables controllers

class GroupsController < ApplicationController
  include SemesterSet

  #before_filter :authorization_filter, :only => [:create, :update, :destroy, :join]
  before_filter :get_group, :only => [:show, :edit, :destroy, :update, :set_start_time, :set_end_time, :clone_pre, :clone]
  skip_before_filter :authorization_filter, :email_helper
  before_filter :set_current_and_next_semester

  def index
    if Cmt::CONFIG[:joingroup_from_index]
      @join = true
    else
      @join = false
    end
    setup_campuses_filter
    setup_semester_filter
    setup_groups

    respond_to do |format|
      format.html do
        layout = authorized?(:index, :manage) ? 'manage' : 'application'
        render :layout => layout
      end
      format.js
    end
  end

  def clone
    @new_group = @group.deep_copy(:semester_id => params[:semester_id])
  end

  def email
    unless authorized?(:new, :emails)
      render(:update) { |page| page.alert("no permission") }
      return
    end
    @group = Group.find(params[:id])
    people = params[:members] ? params[:members] : @group.people
    render(:update) { |page|  page.redirect_to new_email_url(:person => people) }
  end

  unless Cmt::CONFIG[:joingroup_from_index]
    def join
      redirect_to :controller => "signup", :action => "step1_info"
    end
  else
    def join
      join_old
    end
  end

  # lists all relevant groups with a join / interested link for each one
  def join_old
    setup_semester_filter
    setup_campuses_filter
    setup_groups
    @join = true

    respond_to do |format|
      format.html
    end
  end
  
  def show
    # @groups is the list of groups that show up when transferring someone
    if authorized?(:transfer, :groups)
      @groups = get_ministry.all_groups
      @groups += @group.ministry.all_groups
    else
      # use only groups you're a leader of
      @groups = @my.group_involvements.find_all_by_level(Group::LEADER).collect &:group
    end
    @groups.uniq!
    @groups.sort{ |g1, g2| g1.name <=> g2.name }
    s1 = Semester.current
    s2 = Semester.find(s1.id+1)
    s1_list = []
    s2_list = []
    @groups.each do |g|
      case g.semester
      when s1
        s1_list << [ g.name, g.id ]
      when s2
        s2_list << [ g.name, g.id ]
      end
    end
    @grouped_groups = [ [ s1.desc, s1_list ], [ s2.desc, s2_list ] ]

    #@ministry = @group.ministry
    @gi = @group.group_involvements.find_by_person_id @me.id
    respond_to do |format|
      format.html 
      format.js
    end
  end

  def new
    @group = Group.new :country => Cmt::CONFIG[:default_country], 
      :semester_id => @current_semester.id
    respond_to do |format|
      format.html 
      format.js
    end
  end

  def create
    @group = Group.new(params[:group])
    @group.ministry = @ministry # Add bible study to current ministry
    group_save = @group.save
    if (group_save && params[:isleader] == "1")
      @gi = GroupInvolvement.new(:person_id => @person.id, :group_id => @group.id)
      @gi.level = "leader"
      @gi.requested = false
      @gi.save!
      @group = @gi.group
    end
    if group_save
      # If an array of people have been passed in, add them as members
      Array.wrap(params[:person]).each do |person_id|
        GroupInvolvement.create!(:person_id => person_id, :group_id => @group.id, :level => "member", :requested => false)
      end
    end
    @group_type = @group.group_type
    respond_to do |format|
      if group_save
        flash[:notice] = @group.class.to_s.titleize + ' was successfully created.'
        format.html { redirect_to group_url(@group) }
        format.js   { index }
        format.xml  { head :created, :location => groups_url(@group) }
      else
        format.html { render :action => "new" }
        format.js   { render :action => "new" }
        format.xml  { render :xml => @group.errors.to_xml }
      end
    end
  end

  def edit
    @campus = @group.campus
    respond_to do |format|
      format.js
    end
  end

  def update
    if @group.update_attributes(params[:group])
      flash[:notice] = 'Group was successfully updated'
    end
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @group.destroy 
    flash[:notice] = @group.class.to_s.titleize + ' was successfully DELETED.'
    respond_to do |format|
      format.js   { index }
    end
  end
  
  def compare_timetables
    @display_compare_table = true
    @notices = []
    if (Cmt::CONFIG[:hide_poor_status_in_scheduler] == false)
      @notices << "Poor state is currently enabled in the timetables. The 'Compare timetables' feature will not include the poor states during comparison."
    end
    @group = Group.find(params[:id], :include => :people)
    person_ids = params[:members] ? Array.wrap(params[:members]).map(&:to_i) : []
    # if nobody is selected, compare schedules of everyone in group
    if person_ids.present?
      gis = @group.group_involvements.find(:all, :conditions => ["#{_(:person_id, :group_involvement)} in (?)",  person_ids])
    else
      gis = @group.group_involvements
    end
    
    # remove those who haven't submitted timetable (and make sure the group involvement is valid
    # while we're at it, ie. no requests, and valid person)
    @people = gis.reject { |gi| 
      if gi.person.nil? || gi.requested
        true
      elsif !gi.person.free_times.present?
        @notices << "<i>" + gi.person.full_name + "</i> has not submitted their timetable. Hence, they will be excluded from comparison."
        true
      else
        false
      end
    }.collect(&:person)
    
    @comparison_map = Timetable.generate_compare_table(@people)
    respond_to do |format|
      format.js{
         render :update do |page|
            page.replace_html("compare", :partial => "groups/compare_timetables")
         end
      }
    end
  end
  
  def set_start_time
    @notices ||=[]
    stime = params[:time].to_i
    day = params[:day].to_i
    if(!@group.end_time.nil? && params[:time].to_i > @group.end_time )
      @notices << "Start time cannot be greater then end time (which is currently set to " + Date::DAYNAMES[day] + ","+ (Time.now.beginning_of_day + @group.end_time).to_s(:time) + ")"
    else
      @group.start_time = stime
      @group.day  = day
      @group.save!
      @notices << "Group start time set to : " + Date::DAYNAMES[day] + "," + (Time.now.beginning_of_day + stime).to_s(:time)
    end
    
    
    respond_to do |format|
      format.js{
         render :update do |page|
            page.replace_html("notices", :partial => "groups/show_notices")
            page.replace_html("address", :partial => "groups/address")
         end
      }
    end
  end
  
  def set_end_time
    @notices ||=[]
    etime = params[:time].to_i
    day = params[:day].to_i
    if(@group.start_time.nil? )
      @notices << "Start time not yet set. Set start time before setting end time"
    elsif ( etime < @group.start_time )
      @notices << "End time cannot be lesser then start time (which is currently set to " + Date::DAYNAMES[day] + ","+ (Time.now.beginning_of_day + @group.start_time).to_s(:time) + ")"
    else
      @group.end_time = etime
      @group.day  = day
      @group.save!
      @notices << "Group end time set to : " + Date::DAYNAMES[day] + "," + (Time.now.beginning_of_day + etime).to_s(:time)
    end
    respond_to do |format|
      format.js{
         render :update do |page|
            page.replace_html("notices", :partial => "groups/show_notices")
            page.replace_html("address", :partial => "groups/address")
         end
      }
    end
  end
  
  def get_campus
    if params[:campus_id] && !params[:campus_id].blank?
      @campus = Campus.find(params[:campus_id])
    end
    if params[:gt_id]
      @gt = GroupType.find(params[:gt_id])
    end
  end
  
  def find_times
    # # Map all the group members schedules to find an open time in the range submitted
    # @group = Group.find(params[:id], :include => :people)
    # range_start = params[:range_start].to_i
    # range_end = params[:range_end].to_i - (params[:length].present? ? params[:length].to_i : 0)
    # days = params[:days].collect(&:to_i)
    # range = []
    # range_start.step(range_end, Timetable::INTERVAL) {|i| range << i}
    # people = @group.people.reject {|person| person.nil?}
    # possible_times = {}
    # days.collect {|i| possible_times[i] = [] }
    # 
    # # initialize the "Free Times" hash of arrays
    # possible_times.each_key do |day|
    #   Timetable::EARLIEST.to_i.step(Timetable::LATEST.to_i, Timetable::INTERVAL) {|i| possible_times[day] << i if range.include?(i) }
    # end
    # 
    # # Get each person's busy times
    # total_conflict = []
    # people_hash = {}
    # people.each do |person|
    #   free_times = person.free_times.find(:all, :conditions => ["day_of_week IN (?) AND (end_time > ? OR start_time < ?)", 
    #                                   days, range_start, range_end])
    #   unless free_times.empty?
    #     ft_hash = {}
    #     days.collect {|i| ft_hash[i] = [] }
    #     # free_times.each {|bt| ft_hash[bt.day_of_week] = [] }
    #     free_times.each do |bt|
    #       bt.start_time.step(bt.end_time, Timetable::INTERVAL) {|i| ft_hash[bt.day_of_week] << i if days.include?(bt.day_of_week) && range.include?(i) }
    #     end
    #     people_hash[person] = ft_hash
    #   end
    # end
    # # Look for people who have a total conflict
    # people_hash.each_pair do |person, ft_hash|
    #   free = days.collect {|day| possible_times[day] & ft_hash[day] }
    #   total_conflict << person unless free.detect {|a| !a.empty? }
    # end
    # raise total_conflict.inspect
    # # people.each
    # respond_to do |wants|
    #   wants.js
    # end
  end
  
  def clone_pre
    @semesters = Semester.all
  end

  protected

  # TODO: need this?
  def determine_default_campus_filter(ministry)
    # use the MinistryInvolvement whose ministry is at or under ministry,
    # with the Ministry with the least number of campuses
    possible_involvements = @person.ministry_involvements.find(:all, :conditions => ["#{MinistryInvolvement.table_name + '.' + _(:ministry_id, :ministry_involvement)} IN (?)", ministry.self_plus_descendants.collect(&:id)])
    # find one with fewest campuses
    final_mi = possible_involvements.inject(possible_involvements.first) do |mi, min_mi|
      if mi.ministry.campuses.size < min_mi.ministry.campuses.size
        mi
      else
        min_mi
      end
    end
    [ final_mi.ministry.campuses, "m_#{final_mi.ministry.id}" ]
  end

  def setup_campuses_filter
    if is_staff_somewhere
      @campuses = get_ministry.unique_ministry_campuses(false)
    else
      get_person_campuses
      @campuses = @person_campuses
    end

    if params[:campus_id].present?
      requested_campus = Campus.find(:first, :conditions => { 
        Campus._(:id) => (params[:campus_id] || session[:group_campus_filter_id])
      }) || @campuses.first

      @campus = @campuses.detect{ |c| c == requested_campus }
      session[:group_campus_filter_id] = @campus.try(:id)
    end

    @campus_filter_options = [[ "All #{get_ministry.name}", '' ]] + @campuses.collect{ |c| [ c.name, c.id ] }
  end

  def setup_semester_filter
    if params[:semester_id]
      @semester = Semester.find params[:semester_id]
    elsif session[:group_semester_filter_id]
      @semester = Semester.find session[:group_semester_filter_id]
    else
      @semester = @current_semester
    end
    session[:group_semester_filter_id] = @semester.id
    @semester_filter_options = Semester.all.collect{ |s| [ s.desc, s.id ] }
  end

  def setup_groups
    conditions = "(#{Group.__(:campus_id)} is null"
    if (!is_staff_somewhere && (@campus || @campuses.present?)) || 
      (is_staff_somewhere && @campus.present?)
      conditions += " OR #{Group.__(:campus_id)} in (#{@campus.try(:id) || @campuses.collect(&:id).join(',')})"
    elsif is_staff_somewhere
      #ministry_ids = get_ministry.descendants.collect(&:id) << get_ministry.id
      #conditions += " AND ministry_id in (#{ministry_ids.join(",")})"
      conditions += " OR (#{get_ministry.descendants_condition})"
    end
    conditions += ") AND semester_id = #{@semester.id}"
    #@groups = Group.find(:all, :conditions => conditions, :joins => :ministry, :order => "name ASC")
    @groups = Group.find(:all, :conditions => conditions, :joins => [ :ministry ], :include => { :group_involvements => :person }, :order => "#{Group.__(:name)} ASC")
    campuses = Campus.find(:all, :select => "#{Campus._(:id)}, #{Campus._(:name)}", :conditions => [ "#{Campus._(:id)} IN (?)", @groups.collect(&:campus_id).uniq ])
    @campus_id_to_name = Hash[*campuses.collect{ |c| [c.id.to_s, c.name] }.flatten]
  end

end
