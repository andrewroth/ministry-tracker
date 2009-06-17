# Groups associated with an individual
# delete candidate: def find_times is the method for common times but may no
# no longer being used, but is handled in timetables controllers

class GroupsController < ApplicationController
  before_filter :authorization_filter, :only => [:create, :update, :destroy]
  before_filter :get_group, :only => [:show, :edit, :destroy, :update]
  def index
    @groups = @person.groups.find(:all, :group => _(:ministry_id, :group_involvement), 
                                                  :order => Ministry.table_name + '.' + _(:name, :ministry),
                                                  :include => :ministry)
    respond_to do |format|
      format.html do
        layout = authorized?(:new, :people) ? 'manage' : 'application'
        render :layout => layout
      end
      format.js
    end
  end

  def join
    respond_to do |format|
      format.html do
        layout = authorized?(:new, :people) ? 'manage' : 'application'
        render :layout => layout
      end
      format.js
    end
  end
  
  def show
    @ministry = @group.ministry
    respond_to do |format|
      format.html 
      format.js
    end
  end

  def new
    @group = Group.new
    respond_to do |format|
      format.html { render :layout => false }
      format.js
    end
  end

  def create
    @group = Group.new(params[:group])
    @group.ministry = @ministry # Add bible study to current ministry
    respond_to do |format|
      if @group.save
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
    respond_to do |format|
      format.js
    end
  end

  def update
    @group.update_attributes(params[:group])
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
end
