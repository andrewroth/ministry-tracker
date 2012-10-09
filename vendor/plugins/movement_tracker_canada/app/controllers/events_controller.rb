class EventsController < ApplicationController
  unloadable
  layout :get_layout
  
  include PersonForm
  
  require 'ordered_hash_sort.rb'

  skip_before_filter :authorization_filter, :only => [:select_report]
  
  after_filter :sync_event_data_delayed_job, :only => [:attendance]

  before_filter :check_student_visibility, :only => [:show, :edit, :update, :destroy, :attendance, :select_report]
  
  NO_ATTENDEES_EXCEPTION = "There are no registered attendees to this event yet."
  NO_ATTENDEES_AT_CAMPUS_EXCEPTION = "There are no registered attendees to this event from the selected campus,"

  INDIVIDUALS = 'individuals'
  SUMMARY = 'summary'
  DEFAULT_REPORT_SCOPE = SUMMARY
  DEFAULT_REPORT_SORT = "last_name"
  REPORT_SCOPES =
    {
      :summary => {
                    :order => 1,
                    :label => "Summary",
                    :title => "A summary of all attendees to this event",
                    :radio_id => "report_scope_summary",
                    :show => :yes
      },
      :individuals => {
                    :order => 2,
                    :label => "Individuals",
                    :title => "Specific individual attendees to this event",
                    :radio_id => "report_scope_individuals",
                    :show => :yes
      }
    }


  def index
    @cim_reg_events = CimRegEvent.all
    @events = ::Event.all(:order => "created_at desc")

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
    
    setup_event_campuses
  end

  def create
    setup_event_campuses
    
    @event = Event.new(params[:event])
    
    saved = @event.save
    if saved
      @event.update_details_and_attendees_from_eventbrite
      synced = !@event.synced_at.nil? && @event.synced_at.present?
      
      if synced
        EventCampus.all(:conditions => {:event_id => @event.id}).each {|campus| campus.destroy}
        params[:event_campuses].each do |campus_id|
          if Campus.all(:conditions => ["#{Campus._(:id)} = ?", campus_id.to_i]).present?
            ec = EventCampus.new(:event_id => @event.id, :campus_id => campus_id.to_i)
            ec.save
          end
        end if params[:event_campuses].present?
      end
    end

    respond_to do |format|
      if synced && saved
        flash[:notice] = "Eventbrite event '#{@event.title}' was successfully created"
        format.html { redirect_to(events_path) }
      else
        flash[:notice] = 'Something went wrong, please verify that the Eventbrite event ID is correct' if !synced && saved
        format.html { render :action => "new" }
      end
    end
  end
  
  def edit
    @event = Event.find(params[:id])
    
    setup_event_campuses
  end
  
  def update
    setup_event_campuses
    
    @event = Event.find(params[:id])
    
    updated = @event.update_attributes(params[:event])
    if updated
      @event.update_details_and_attendees_from_eventbrite
      synced = @event.synced_at != nil
      
      if synced
        EventCampus.all(:conditions => {:event_id => @event.id}).each {|campus| campus.destroy}
        params[:event_campuses].each do |campus_id|
          if Campus.all(:conditions => ["#{Campus._(:id)} = ?", campus_id.to_i]).present?
            ec = EventCampus.new(:event_id => @event.id, :campus_id => campus_id.to_i)
            ec.save
          end
        end if params[:event_campuses].present?
      end
    end

    respond_to do |format|
      if synced && updated
        flash[:notice] = "Eventbrite event '#{@event.title}' was successfully updated"
        format.html { redirect_to(events_path) }
      else
        flash[:notice] = 'Could not get event info from Eventbrite, verify that the Eventbrite event ID is correct' if !synced && updated
        format.html { render :action => "new" }
      end
    end
  end
  
  def destroy
    @event = Event.find(params[:id])
    @event.event_attendees.destroy_all
    @event.event_campuses.destroy_all
    @event.destroy

    unless @event.errors.empty?
      flash[:notice] = "WARNING: Couldn't delete event because:"
      @event.errors.full_messages.each { |m| flash[:notice] << "<br/>" << m }
    end

    respond_to do |format|
      format.html { redirect_to(events_path) }
    end
  end
  

  def attendance
    session[:attendance_campus_id] = nil unless session[:attendance_campus_id].present?
    session[:attendance_report_scope] = DEFAULT_REPORT_SCOPE unless session[:attendance_report_scope].present?
    session[:attendance_report_sort] = DEFAULT_REPORT_SORT unless session[:attendance_report_sort].present?

    setup_attendance_report_from_session
    setup_event
  end


  def select_report
    session[:attendance_report_scope] = params['attendance_report_scope'] if params['attendance_report_scope'].present?

    session[:attendance_report_sort] = params['attendance_report_sort'] if params['attendance_report_sort'].present? &&
      params['attendance_report_sort'] != "null" && params['attendance_report_sort'] != "undefined" # javascript may return null or undefined

    session[:attendance_campus_id] = params['attendance_campus_id'] if params['attendance_campus_id'].present? &&
      params['attendance_campus_id'] != "null" && params['attendance_campus_id'] != "undefined" # javascript may return null or undefined

    setup_event
    setup_my_campus
    setup_attendance_report_from_session

    case @report_scope
    when SUMMARY
      setup_summary if authorized?(:show_my_campus_summary, :events) || authorized?(:show_all_campuses_summaries, :events)
    when INDIVIDUALS
      setup_individuals if authorized?(:show_my_campus_individuals, :events) || authorized?(:show_all_campuses_individuals, :events)
    end

    respond_to do |format|
      format.js
    end
  end


  private


  def setup_report_scope_radios
    @attendance_scope_radios = []
    REPORT_SCOPES.each { |k,v| @attendance_scope_radios << get_initialized_scope_radio(k.to_s ,v) }
    @attendance_scope_radios.sort! {|x,y| x[:order] <=> y[:order] }
  end


  def get_initialized_scope_radio(key, scope)
    {
      :order => scope[:order],
      :checked => @report_scope == key ? true : false,
      :disabled => false,
      :value => key,
      :label => scope[:label],
      :title => scope[:title],
      :show => show_scope_radio(scope)
    }
  end

  def show_scope_radio(scope)
    case scope[:show]
      when :yes
        return true
      when :no
        return false
    end
  end

  def setup_attendance_report_from_session
    
    setup_my_campus unless @my_campuses.present?
    
    setup_event unless @event.present?
    
    @report_scope = session[:attendance_report_scope]
    @report_sort = session[:attendance_report_sort]
    @selected_campus_id = session[:attendance_campus_id].present? ? session[:attendance_campus_id] : @my_campuses.first.id
    @selected_campus = @selected_campus_id.present? ? Campus.first(:conditions => {:campus_id => @selected_campus_id}) : nil
    
    # make sure the selected campus is associated to the chosen event and that it's within my involvements
    unless @selected_campus && @event.campuses.include?(@selected_campus) && (@my_campuses.include?(@selected_campus) || authorized?(:show_all_campuses_individuals, :events))
      
      my_campuses_at_event = @event.campuses.select { |ec| @my_campuses.include? ec }
      
      if my_campuses_at_event.blank? && !authorized?(:show_all_campuses_individuals, :events)
        flash[:notice] = "Sorry, that event isn't associated with any of your campuses"
        redirect_to :controller => "dashboard", :action => "index"
        return
      elsif authorized?(:show_all_campuses_individuals, :events)
        @selected_campus = @event.campuses.first if @selected_campus.desc != "Other"
      else
        @selected_campus = my_campuses_at_event.first
      end
      @selected_campus_id = @selected_campus.id
    end
    
    setup_report_scope_radios
    
    if @report_scope == INDIVIDUALS &&
        (authorized?(:show_all_campuses_individuals, :events) ||
          (authorized?(:show_my_campus_individuals, :events) && @my_campuses.size > 1))
      @show_campus_select = true
    else
      @show_campus_select = false
    end
    
    @attendance_campuses = []
    
    @scope_radio_selected_id = REPORT_SCOPES[:"#{@report_scope}"][:radio_id]
    
    @attendance_summary = @report_scope == SUMMARY ? true : false
    
    @selected_results_div_id = "attendanceResults"
  end


  def setup_summary
    begin
      @results_partial = "attendance_summary_cached"
      return if Rails.cache.read([@eb_event.id, "summary", Time.now.to_date, Time.now.hour]).present?

      @campus_summaries = ActiveSupport::OrderedHash.new
      @campus_summary_totals = {:males => 0, :females => 0, :first_year => 0, :upper_year => 0}

      raise Exception.new(NO_ATTENDEES_EXCEPTION) if @eb_event.num_attendee_rows.blank? || @eb_event.num_attendee_rows == 0
      attendees = @eb_event.attendees if @eb_event.present?
      raise Exception.new() if attendees.blank?

      attendees.each do |attendee|
        eb_campus = attendee.answer_to_question(eventbrite[:campus_question])

        next unless eb_campus

        matched_campus = @my_campuses.select {|c| c.matches_eventbrite_campus(eb_campus)}[0]
        
        if authorized?(:show_all_campuses_summaries, :events) || matched_campus.present?

          @campus_summaries[eb_campus.to_s] = {:males => 0, :females => 0, :first_year => 0, :upper_year => 0} if @campus_summaries[eb_campus].nil?

          case attendee.gender.try(:downcase)
          when eventbrite[:female].downcase
            @campus_summaries[eb_campus][:females] += 1
            @campus_summary_totals[:females] += 1
          when eventbrite[:male].downcase
            @campus_summaries[eb_campus][:males] += 1
            @campus_summary_totals[:males] += 1
          end

          case attendee.answer_to_question(eventbrite[:year_question]).try(:downcase)
          when eventbrite[:first_year][:en].downcase, eventbrite[:first_year][:fr].downcase
            @campus_summaries[eb_campus][:first_year] += 1
            @campus_summary_totals[:first_year] += 1
          else
            @campus_summaries[eb_campus][:upper_year] += 1
            @campus_summary_totals[:upper_year] += 1
          end

        end
      end

      if authorized?(:show_all_campuses_summaries, :events) && ( @eb_event.num_attendee_rows != @campus_summary_totals[:males]+@campus_summary_totals[:females] ||
         @eb_event.num_attendee_rows != @campus_summary_totals[:first_year]+@campus_summary_totals[:upper_year] )

        @missing_attendees = true
      end

      @campus_summaries = @campus_summaries.sorted_hash { |a,b| a[0].upcase <=> b[0].upcase  }

      @report_description = "Attendance Summary"

    rescue Exception => e
      if e.message == NO_ATTENDEES_EXCEPTION
        @report_description = NO_ATTENDEES_EXCEPTION
        @results_partial = "error"
      else
        setup_error_rescue
      end
    end
  end


  def setup_individuals
    begin
      setup_attendance_report_from_session unless @selected_campus.present?

      @attendance_campuses = @event.campuses
      @attendance_campuses.sort! {|a,b| a.desc <=> b.desc} if @attendance_campuses.size > 1
      @show_campus_select = false if @attendance_campuses.size == 1

      @results_partial = "attendance_individuals_cached"
      return if Rails.cache.read([@eb_event.id, "individuals", @selected_campus.id, @report_sort, Time.now.to_date, Time.now.hour]).present?


      raise Exception.new(NO_ATTENDEES_EXCEPTION) if @eb_event.num_attendee_rows.blank? || @eb_event.num_attendee_rows == 0
      attendees = @eb_event.attendees if @eb_event.present?
      raise Exception.new() if attendees.blank?
      

      @campus_individuals = ActiveSupport::OrderedHash.new

      attendees.each do |attendee|
        eb_campus = attendee.answer_to_question(eventbrite[:campus_question]) # answer is in the format "campus.desc (campus.short_desc)"

        next unless eb_campus.present?

        # if has permission to see info from all campuses
        if authorized?(:show_all_campuses_individuals, :events)
          add_attendee_to_hash(@campus_individuals, attendee) if @selected_campus.matches_eventbrite_campus(eb_campus)

        # else if only has permission to see info from their own campus
        elsif authorized?(:show_my_campus_individuals, :events)
          matched_campus = @my_campuses.select {|c| c.matches_eventbrite_campus(eb_campus)}[0]

          if matched_campus.present?
            add_attendee_to_hash(@campus_individuals, attendee) if @selected_campus.matches_eventbrite_campus(eb_campus)
          end
        end
      end


      raise Exception.new(NO_ATTENDEES_AT_CAMPUS_EXCEPTION) if @campus_individuals.blank?


      if @report_sort.present? && @campus_individuals.size > 1
        @report_sort = DEFAULT_REPORT_SORT unless @campus_individuals.first[1][@report_sort.to_sym].present?
        
        unless @report_sort == "amount_paid"
          @campus_individuals = @campus_individuals.sorted_hash { |a,b| a[1][@report_sort.to_sym].upcase <=> b[1][@report_sort.to_sym].upcase }
        else
          @campus_individuals = @campus_individuals.sorted_hash { |a,b| a[1][@report_sort.to_sym].to_f <=> b[1][@report_sort.to_sym].to_f }
        end
      end

      if authorized?(:show_all_campuses_individuals, :events) && (@eb_event.num_attendee_rows != @campus_individuals)
        @missing_attendees = true
      end

      @report_description = "Attendees from #{@selected_campus.desc}"


    rescue Exception => e
      if e.message == NO_ATTENDEES_EXCEPTION
        @report_description = NO_ATTENDEES_EXCEPTION
        @results_partial = "error"
      elsif e.message == NO_ATTENDEES_AT_CAMPUS_EXCEPTION
        @report_description = "#{NO_ATTENDEES_AT_CAMPUS_EXCEPTION} #{@selected_campus.desc}."
        @results_partial = "error"
      else
        setup_error_rescue
      end
    end
  end


  def add_attendee_to_hash(hash, attendee)
    hash["#{hash.size + 1}"] = {
      :first_name => attendee.first_name,
      :last_name => attendee.last_name,
      :gender => attendee.gender,
      :email => attendee.email,
      :home_phone => attendee.home_phone,
      :cell_phone => attendee.cell_phone,
      :work_phone => attendee.work_phone,
      :amount_paid => attendee.amount_paid,
      :year => attendee.answer_to_question(eventbrite[:year_question]),
      :campus => attendee.answer_to_question(eventbrite[:campus_question])
    }
  end


  def setup_event
    @event ||= Event.find(params[:id])

    begin
      @eventbrite_user ||= EventBright.setup_from_initializer()
      @eb_event ||= EventBright::Event.new(@eventbrite_user, {:id => @event.eventbrite_id})
    rescue Exception => e
      setup_error_rescue
    end
  end

  def setup_my_campus
    if @me.is_staff_somewhere?
      @my_campuses = get_ministry.unique_campuses
      @my_campuses << Campus.find_by_campus_desc("Other")
    else
      @my_campuses = @my.campuses
    end
  end

  def setup_error_rescue
    @report_description = "Sorry, we had trouble connecting with <a href='#{eventbrite[:c4c_events_link]}'>Eventbrite</a>, please try again later."
    @results_partial = "error"
  end

  def sync_event_data_delayed_job
    ::Event.send_later(:sync_unsynced_events, params[:force_sync_all])
  end
  
  def get_layout
    params[:action] == 'index' ? 'manage' : 'application'
  end
  
  def check_student_visibility
    setup_event
    unless @event.visible_to_students || is_staff_somewhere(@me) || is_ministry_admin
      flash[:notice] = "Sorry, that event's not for you"
      redirect_to :controller => "dashboard", :action => "index"
    end
  end

  def setup_event_campuses
    setup_campuses
    @campuses << Campus.find_by_campus_desc("Other")
  end
end
