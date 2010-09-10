class EventsController < ApplicationController
  unloadable

  require 'ordered_hash_sort.rb'

  skip_before_filter :authorization_filter, :only => [:select_report]

  
  SELECTED_CAMPUS_EXCEPTION = "Selected campus not relevant to this event."

  INDIVIDUALS = 'individuals'
  SUMMARY = 'summary'
  DEFAULT_REPORT_SCOPE = SUMMARY
  DEFAULT_REPORT_SORT = "last_name"
  REPORT_SCOPES =
    {
      :summary => {
                    :order => 1,
                    :label => "Attendance Summary",
                    :title => "See a summary of all attendees to this event.",
                    :radio_id => "report_scope_summary",
                    :show => :yes
      },
      :individuals => {
                    :order => 2,
                    :label => "Individual Attendees",
                    :title => "See individual attendees to this event.",
                    :radio_id => "report_scope_individuals",
                    :show => :yes
      }
    }


  def attendance
    session[:attendance_campus_id] = 0 unless session[:attendance_campus_id].present?
    session[:attendance_report_scope] = DEFAULT_REPORT_SCOPE unless session[:attendance_report_scope].present?
    session[:attendance_report_sort] = DEFAULT_REPORT_SORT unless session[:attendance_report_sort].present?

    setup_attendance_report_from_session
    setup_event
  end


  def select_report
    
    session[:attendance_report_scope] = params['attendance_report_scope'] if params['attendance_report_scope'].present?
    session[:attendance_report_sort] = params['attendance_report_sort'] if params['attendance_report_sort'].present?

    # don't store selected_campus in session to prevent SELECTED_CAMPUS_EXCEPTION (see setup_individuals)
    @selected_campus_id = params['attendance_campus_id'].present? ? params['attendance_campus_id'] : nil
    @selected_campus = @selected_campus_id.present? ? Campus.first(:conditions => {:campus_id => @selected_campus_id}) : nil


    setup_attendance_report_from_session

    setup_event
    setup_my_campus

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


  def setup_report_scope_radios
    @attendance_scope_radios = []
    REPORT_SCOPES.each { |k,v| @attendance_scope_radios << get_initialized_scope_radio(k.to_s ,v) }
    @attendance_scope_radios.sort! {|x,y| x[:order] <=> y[:order] }
  end


  def get_initialized_scope_radio(key, scope)
    {
      :order => scope[:order],
      :checked => @attendance_report_scope == key ? true : false,
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

    setup_my_campus
    setup_report_scope_radios

    @report_scope = session[:attendance_report_scope]
    @report_sort = session[:attendance_report_sort]

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
      @campus_summaries = ActiveSupport::OrderedHash.new
      @campus_summary_totals = {:males => 0, :females => 0}

      attendees = @eb_event.attendees if @eb_event.present?
      raise Exception.new() if attendees.blank?


      attendees.each do |attendee|
        eb_campus = attendee.answer_to_question(eventbrite[:campus_question])

        matched_campus = @my_campuses.select {|c| c.matches_eventbrite_campus(eb_campus)}[0]
        
        if authorized?(:show_all_campuses_summaries, :events) || matched_campus.present?

          @campus_summaries[eb_campus.to_s] = {:males => 0, :females => 0} if @campus_summaries[eb_campus].nil?

          case attendee.gender
          when eventbrite[:female]
            @campus_summaries[eb_campus][:females] += 1
            @campus_summary_totals[:females] += 1
          when eventbrite[:male]
            @campus_summaries[eb_campus][:males] += 1
            @campus_summary_totals[:males] += 1
          end

        end
      end

      @campus_summaries = @campus_summaries.sorted_hash { |a,b| a[0].upcase <=> b[0].upcase  }

      @report_description = "Attendance Summary"

      @results_partial = "attendance_summary"
    rescue
      setup_error_rescue
    end
  end


  def setup_individuals
    retries = 1 # use to prevent infinite loop
    begin

      attendees = @eb_event.attendees if @eb_event.present?
      raise Exception.new() if attendees.blank?
      
      @selected_campus = @my_campuses.first unless authorized?(:show_all_campuses_individuals, :events)

      unless(@selected_campus.present?)
        eb_campus = attendees.first.answer_to_question(eventbrite[:campus_question])
        @selected_campus = Campus::find_campus_from_eventbrite(eb_campus)
        @selected_campus_id = @selected_campus.id
      end


      @campus_individuals = ActiveSupport::OrderedHash.new
      campuses = {}

      attendees.each do |attendee|
        eb_campus = attendee.answer_to_question(eventbrite[:campus_question]) # answer is in the format "campus.desc (campus.short_desc)"

        # if has permission to see info from all campuses
        if authorized?(:show_all_campuses_individuals, :events)
          campuses[eb_campus.to_s] = Campus::find_campus_from_eventbrite(eb_campus) # use hash to prevent duplicates

          add_attendee_to_hash(@campus_individuals, attendee) if @selected_campus.matches_eventbrite_campus(eb_campus)

        # else if only has permission to see info from their own campus
        elsif authorized?(:show_my_campus_individuals, :events)
          matched_campus = @my_campuses.select {|c| c.matches_eventbrite_campus(eb_campus)}[0]

          if matched_campus.present?
            campuses[eb_campus.to_s] = matched_campus

            add_attendee_to_hash(@campus_individuals, attendee) if @selected_campus.matches_eventbrite_campus(eb_campus)
          end
        end
      end

      # we don't know which campuses are available for selection until we've looped through all attendees
      # this means it's possible to select a campus which no one attending the event is from
      # if that happens we need to select a new campus and go through the list of attendees again
      if campuses.present? && campuses.index(@selected_campus).nil?
        raise Exception.new(SELECTED_CAMPUS_EXCEPTION)
      end

      # convert campus hash to an array for collection select
      @attendance_campuses = []
      campuses.each { |title, campus| @attendance_campuses << campus }
      @attendance_campuses.sort! {|a,b| a.desc <=> b.desc} if @attendance_campuses.size > 1


      if @report_sort.present? && @campus_individuals.size > 1
        @report_sort = DEFAULT_REPORT_SORT unless @campus_individuals.first[1][@report_sort.to_sym].present?
        @campus_individuals = @campus_individuals.sorted_hash { |a,b| a[1][@report_sort.to_sym].upcase <=> b[1][@report_sort.to_sym].upcase }
      end


      @report_description = "Individual Attendees from #{@selected_campus.desc}"

      @results_partial = "attendance_individuals"

    rescue Exception => e
      if e.message == SELECTED_CAMPUS_EXCEPTION && retries > 0
        
        eb_campus = attendees.first.answer_to_question(eventbrite[:campus_question])
        @selected_campus = Campus::find_campus_from_eventbrite(eb_campus)
        @selected_campus_id = @selected_campus.id

        retries -= 1
        retry unless retries < 0
        
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
      :work_phone => attendee.work_phone
    }
  end


  def setup_event
    @event = Event.find(params[:id])
    @eventbrite_user ||= EventBright.setup_from_initializer()
    @eb_event = EventBright::Event.new(@eventbrite_user, {:id => @event.eventbrite_id})
  end

  def setup_my_campus
    @my_campuses = @my.campuses
  end

  def setup_error_rescue
    @report_description = "Oh noes..."

    @results_partial = "error"
  end
end
