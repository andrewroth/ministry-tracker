# Groups associated with an individual
# delete candidate: def find_times is the method for common times but may no
# no longer being used, but is handled in timetables controllers

class GroupsController < ApplicationController
  #before_filter :authorization_filter, :only => [:create, :update, :destroy, :join]
  before_filter :get_group, :only => [:show, :edit, :destroy, :update, :set_start_time, :set_end_time]
  skip_before_filter :authorization_filter, :email_helper

  def index
    @join = false
    setup_campuses_filter
    setup_groups

    respond_to do |format|
      format.html do
        layout = authorized?(:index, :manage) ? 'manage' : 'application'
        render :layout => layout
      end
      format.js
    end
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

  # lists all relevant groups with a join / interested link for each one
  def join
    setup_campuses_filter
    setup_groups
    @join = true

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
      @campuses = get_ministry.campuses
    else
      get_person_campuses
      @campuses = @person_campuses
    end

    requested_campus = Campus.find(:first, :conditions => { 
        Campus._(:id) => (params[:campus_id] || session[:group_campus_filter_id])
      }) || @campuses.first
    @campus = @campuses.detect{ |c| c == requested_campus }
    session[:group_campus_filter_id] = @campus.try(:id)

    @campus_filter_options = [[ "All #{get_ministry.name}", '' ]] + @campuses.collect{ |c| [ c.name, c.id ] }
  end

  def setup_groups
    conditions = 'campus_id is null'
    if @campus || @campuses.present?
      conditions += " OR campus_id in (#{@campus.try(:id) || @campuses.collect(&:id).join(',')})"
    end
    if is_staff_somewhere
      @groups = get_ministry.groups.find(:all, :conditions => conditions)
    else
      @groups = Group.find(:all, :conditions => conditions)
    end
  end
end
