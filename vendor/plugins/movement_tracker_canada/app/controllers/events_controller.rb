class EventsController < ApplicationController
  unloadable

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
    session[:attendance_campus_id] = params['attendance_campus'] if params['attendance_campus'].present?
    session[:attendance_report_scope] = params['attendance_report_scope'] if params['attendance_report_scope'].present?

    setup_attendance_report_from_session

    case @report_scope
    when SUMMARY
      setup_summary
    when INDIVIDUALS
      setup_individuals
    end

    respond_to do |format|
      format.js
    end
  end


  def setup_report_scope_radios
    @attendance_scope_radios = []
    REPORT_SCOPES.each { |k,v| @attendance_scope_radios << get_initialized_scope_radio(k.to_s ,v) }
    @attendace_scope_radios = @attendance_scope_radios.sort {|x,y| x[:order] <=> y[:order] }
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

    @scope_radio_selected_id = REPORT_SCOPES[:"#{@report_scope}"][:radio_id]


    @attendance_summary = @report_scope == SUMMARY ? true : false

    @selected_results_div_id = "attendanceResults"
  end


  def setup_summary
    setup_event

    @campus_summaries = {}
    @campus_summary_totals = {:males => 0, :females => 0}

    @eb_event.attendees.each do |attendee|
      campus = attendee.answer_to_question("Your Campus")

      @campus_summaries[campus.to_s] = {:males => 0, :females => 0} if @campus_summaries[campus].nil?

      case attendee.gender
      when "Female"
        @campus_summaries[campus][:females] += 1
        @campus_summary_totals[:females] += 1
      when "Male"
        @campus_summaries[campus][:males] += 1
        @campus_summary_totals[:males] += 1
      end
    end

    @report_description = "Attendance Summary of #{@eb_event.title}"

    @results_partial = "attendance_summary"
  end


  def setup_individuals
    @report_description = "Individual Attendees to #{@eb_event.title}"

    @results_partial = "attendance_individuals"
  end


  def setup_event
    @event ||= Event.find(params[:id])
    @eventbrite_user ||= EventBright.setup_from_initializer()
    @eb_event ||= EventBright::Event.new(@eventbrite_user, {:id => @event.eventbrite_id})
  end

end
