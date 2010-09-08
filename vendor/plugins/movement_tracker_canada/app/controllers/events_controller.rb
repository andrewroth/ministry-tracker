class EventsController < ApplicationController
  unloadable

  skip_before_filter :authorization_filter, :only => [:select_report]

  
  SELECTED_CAMPUS_EXCEPTION = "Selected campus not relevant to this event."

  INDIVIDUALS = 'individuals'
  SUMMARY = 'summary'
  DEFAULT_REPORT_SCOPE = SUMMARY
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

    @event = Event.find(params[:id])

    setup_attendance_report_from_session


    @eventbrite_user = EventBright.setup_from_initializer()

    @eb_event = EventBright::Event.new(@eventbrite_user, {:id => @event.eventbrite_id})
  end


  def select_report
    
    session[:attendance_report_scope] = params['attendance_report_scope'] if params['attendance_report_scope'].present?

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

    setup_report_scope_radios

    @report_scope = session[:attendance_report_scope]

    @show_campus_select = (@report_scope == INDIVIDUALS && authorized?(:show_all_campuses_individuals, :events)) ? true : false

    @attendance_campuses = []

    @scope_radio_selected_id = REPORT_SCOPES[:"#{@report_scope}"][:radio_id]

    @attendance_summary = @report_scope == SUMMARY ? true : false

    @selected_results_div_id = "attendanceResults"
  end


  def setup_summary
    @campus_summaries = {}
    @campus_summary_totals = {:males => 0, :females => 0}

    attendees = @eb_event.attendees

    
    attendees.each do |attendee|
      eb_campus = attendee.answer_to_question(eventbrite[:campus_question])

      if authorized?(:show_all_campuses_summaries, :events) || @my_campus.matches_eventbrite_campus(eb_campus)

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


    @report_description = "Attendance Summary"

    @results_partial = "attendance_summary"
  end


  def setup_individuals
    attendees = @eb_event.attendees
    
    unless(@selected_campus.present?)
      eb_campus = attendees.first.answer_to_question(eventbrite[:campus_question])
      @selected_campus = Campus::find_campus_from_eventbrite(eb_campus)
      @selected_campus_id = @selected_campus.id
    end


    already_retried = false # use to prevent infinite loop
    begin
      @campus_individuals = {}
      campuses = {}

      attendees.each do |attendee|
        eb_campus = attendee.answer_to_question(eventbrite[:campus_question]) # answer is in the format "campus.desc (campus.short_desc)"

        # if has permission to see info from all campuses
        if authorized?(:show_all_campuses_individuals, :events)
          campuses[eb_campus.to_s] = Campus::find_campus_from_eventbrite(eb_campus) # use hash to prevent duplicates

          add_attendee_to_hash(@campus_individuals, attendee) if @selected_campus.matches_eventbrite_campus(eb_campus)

        # else if only has permission to see info from their own campus
        elsif authorized?(:show_my_campus_individuals, :events) && @my_campus.matches_eventbrite_campus(eb_campus)
          campuses[eb_campus.to_s] = @my_campus

          add_attendee_to_hash(@campus_individuals, attendee) if @selected_campus.matches_eventbrite_campus(eb_campus)
        end
      end


      # we don't know which campuses are available for selection until we've looped through all attendees
      # this means it's possible to select a campus which no one attending the event is from
      # if that happens we need to select a new campus and go through the list of attendees again
      if campuses.index(@selected_campus).nil?
        raise SELECTED_CAMPUS_EXCEPTION
      end

    rescue Exception => e
      if e.message == SELECTED_CAMPUS_EXCEPTION && !already_retried
        
        eb_campus = attendees.first.answer_to_question(eventbrite[:campus_question])
        @selected_campus = Campus::find_campus_from_eventbrite(eb_campus)
        @selected_campus_id = @selected_campus.id

        retry
      end
    end


    # convert campus hash to an array for collection select
    @attendance_campuses = []
    campuses.each { |title, campus| @attendance_campuses << campus }
    @attendance_campuses.sort! {|a,b| a.desc <=> b.desc} if @attendance_campuses.size > 1


    @report_description = "Individual Attendees from #{@selected_campus.desc}"

    @results_partial = "attendance_individuals"
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
    my_campuses_ids = get_ministry.unique_campuses.collect { |c| c.id }
    @my_campus = Campus.find(my_campuses_ids[0])
  end
end
