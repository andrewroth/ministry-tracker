# Groups associated with an individual
# delete candidate: def find_times is the method for common times but may no
# no longer being used, but is handled in timetables controllers

class GroupsController < ApplicationController
  #before_filter :authorization_filter, :only => [:create, :update, :destroy, :join]
  before_filter :get_group, :only => [:show, :edit, :destroy, :update, :set_start_time, :set_end_time]

  def index
    @join = false
    if params[:all] == 'true'
      @groups = @person_campus_groups = @ministry.groups.find(:all, :include => [:group_type, :group_involvements, :campus], :order => _(:name, :group))
    else
      get_person_campus_groups
      @groups = @person_campus_groups
    end

    setup_campus_filter

    respond_to do |format|
      format.html do
        layout = authorized?(:index, :manage) ? 'manage' : 'application'
        render :layout => layout
      end
      format.js
    end
  end

  # lists all relevant groups with a join / interested link for each one
  def join
    if @person.active_campuses.empty?
      flash[:notice] = "You do not have a campus chosen.  <A HREF='#{edit_person_url(@person.id, :set_campus_requested => true)}'>Click here</A> to set your campus, so that we can display the groups you are looking for."
    end
    @join = true
    get_person_campus_groups
    @groups = @person_campus_groups
    setup_campus_filter
    respond_to do |format|
      format.html
    end
  end
  
  def show
    get_person_campus_groups
    @groups = @person_campus_groups
    @ministry = @group.ministry
    @gi = @group.group_involvements.find_by_person_id @me.id
    respond_to do |format|
      format.html 
      format.js
    end
  end

  def new
    @group = Group.new :country => Cmt::CONFIG[:default_country]
    respond_to do |format|
      format.html { render :layout => false }
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
    @group_type = @group.group_type
    respond_to do |format|
      if group_save
        flash[:notice] = @group.class.to_s.titleize + ' was successfully created.'
        format.html { redirect_to groups_url }
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
    @campus = Group.find_by_id(params[:id]).campus
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
        @notices << "<i>" + gi.person.full_name + "</i> has not submitted his timetable. Hence will be excluded from comparison."
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
  
  def build_campus_filter_options(ministry)
    if ministry.campuses.length > 0
      title = "#{ministry.name} Campuses"
      campuses = ministry.campuses.length > 1 ? [ [ "All", "m_#{ministry.id}" ] ] : []
      campuses += ministry.campuses.collect{ |pc| [ "#{pc.name}", "m_#{ministry.id}_c#{pc.id}" ] }
      r = [ [ title, campuses ] ]
    else
      r = []
    end

    return r if ministry.ministries_count == 0
    
    subministries = ministry.children
    for sub in subministries
      r += build_campus_filter_options(sub)
    end

    r
  end

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

  # return [ campuse-filter-array, default-value-to-select-in-dropdown ]
  def campus_filter_from_param
    return nil unless params[:campus_filter].present?
    cf = params[:campus_filter]
    if cf =~ /m_(\d+)$/
      m = Ministry.find $1
      # ensure it's valid
      m = get_ministry unless get_ministry.self_plus_descendants.include?(m)
      return [ m.campuses, params[:campus_filter] ]
    elsif cf =~ /m_(\d+)_c(\d+)/
      campuses = get_person_campuses.find_all{ |c| c.id.to_s == $2 }
      [ campuses, params[:campus_filter] ]
    end
  end

  def get_ministry_with_three_levels
    Ministry.find get_ministry.id, :include => [ { :children => [ { :children => :campuses }, :campuses ] }, :campuses ]
  end

  def setup_campus_filter
    get_person_campuses
    role = get_ministry_involvement(get_ministry).ministry_role
    if role.is_a?(StaffRole)
      @campus_filter_options = build_campus_filter_options(get_ministry_with_three_levels)
      @campus_filter, @campus_filter_default = campus_filter_from_param || determine_default_campus_filter(get_ministry)
      campus_filter_ids = @campus_filter.collect &:id
      @groups = @person_campus_groups = @groups.find_all{ |g| campus_filter_ids.include?(g.campus_id) }
    elsif role.is_a?(StudentRole)
      @campus_filter_options = [ [ 'Your Campuses' , @person_campuses.collect{ |c| [ c.name, c.id ] } ] ]
      @campus_filter = @person_campuses.first
      @campus_filter_default = @person_campuses.id
    end
  end

  #returns groups with no campus or campuses the user is assoicated with and the user hasn't joined
end
