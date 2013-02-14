# Provides the following information:
# * Count of people in ministry
# * movement count (definition unclear)
# * names of newest people added
class DashboardController < ApplicationController
  include SemesterSet
  include Pat
  before_filter :set_current_and_next_semester

  def setup
    setup_years
    setup_months
  end

  def index
    set_notices
    @people_in_ministries = MinistryInvolvement.count(:conditions => ["#{_(:ministry_id, :ministry_involvement)} IN(?)", @ministry.id ])
    @movement_count = @my.ministry_involvements.length

    @ministry_ids ||= @my.ministry_involvements.collect(&:ministry_id).join(',')

    setup_pat_stats
    setup_insights

    if  @ministry_ids.present? #&& @ministry.campus_ids.present?
       @newest_people = Person.find(:all, :conditions => "#{MinistryInvolvement.table_name}." + _(:ministry_id, :ministry_involvement) + " IN (#{@ministry_ids})", # OR #{CampusInvolvement.table_name}.#{_(:campus_id, :campus_involvement)} IN (#{@ministry.campus_ids.join(',')})
                                         :order => "#{Person.table_name}.#{_(:created_at, :person)} desc", :limit => 4, :joins => [:ministry_involvements, :campus_involvements])
    end

    @show_my_events = Event.first.present? ? true : false

    # update my schedule flash notice
    my_timetable = (@my.timetable || Timetable.create(:person_id => @me.id))
    if my_timetable.updated_at.blank? || my_timetable.updated_at == my_timetable.created_at
      flash[:notice] = "#{t("dashboard.update_schedule_msg")}  <a href='#{person_timetable_path(@me.id, my_timetable.id)}'>#{t("dashboard.update_schedule_title")}</a>"
    end
  end

  def events
    begin

      if @me.is_staff_somewhere?
        @my_campuses = get_ministry.unique_campuses
      else
        @my_campuses = @my.campuses
      end
      my_campuses_ids = @my_campuses.collect { |c| c.id }

      if my_campuses_ids.present? then
        my_event_ids = EventCampus.find(:all, :conditions => "#{_(:campus_id, :event_campuses)} IN (#{my_campuses_ids.join(',')})").collect { |ec| ec.event_id }
      end

      if my_event_ids.present? && @my_campuses.present? then

        my_events = Event.find(:all, :conditions => "#{Event.table_name}.#{_(:id, :event)} IN (#{my_event_ids.join(',')}) "+
                                                    "#{!is_staff_somewhere(@me) ? "AND #{Event.table_name}.visible_to_students = true" : ''}")

        @eventbrite_events = []
        live_event_ids = [] # get only the event_ids for live events, right now we get the event status from Eventbrite

        @eventbrite_user ||= ::EventBright.setup_from_initializer()

        my_events.each do |event|
          eb_event = ::EventBright::Event.new(@eventbrite_user, {:id => event.eventbrite_id})

          if display_event(eb_event) then
            if @my_campuses.size == 1 && event.campuses.size > 1 then
              attendees = event.all_attendees_from_campus(Campus.find(my_campuses_ids.first))
              eb_event.attributes[:my_campus_num_attendees] = attendees.size
            end

            @eventbrite_events << eb_event
            live_event_ids << event.id

            if authorized?(:attendance, :events)
              eb_event.attributes[:link_to_report] = url_for(:controller => 'events', :action => 'attendance', :id => event.id)
            end
          end
        end

        if live_event_ids.present? then
          #find all event_groups that the live events are in
          event_group_ids = Event.find(:all, :conditions => "#{Event.table_name}.#{_(:id, :event)} IN (#{live_event_ids.join(',')})").collect { |e| e.event_group_id }
          @event_groups = ::EventGroup.find(:all, :conditions => "#{::EventGroup.table_name}.#{_(:id, :event_group)} IN (#{event_group_ids.join(',')})")

          #organize eventbrite events by group
          @eventbrite_events_by_group = {}
          @event_groups.each { |group| @eventbrite_events_by_group["#{group.id}"] = [] }

          @eventbrite_events.each do |eb_event|
            event = Event.first(:conditions => {:registrar_event_id => eb_event.id})
            @eventbrite_events_by_group["#{event.event_group_id}"] << eb_event
          end
        end
      end

    rescue Exception => e
      @eventbrite_error = e.message
      @eventbrite_error ||= e
      Rails.logger.info "\tEventBright API ERROR \t#{e.message}"
    end

    respond_to do |format|
      format.js
    end

  end

  protected

  def get_eventbrite_event_from_event(event)
    @eventbrite_user ||= ::EventBright.setup_from_initializer()
    eb_event = ::EventBright::Event.new(@eventbrite_user, {:id => event.eventbrite_id})
    raise Exception.new("Got blank Eventbrite api_object back") if eb_event.id.blank? || eb_event.attributes.blank?
  end

  def display_event(eb_event)
    display = false

    # display event if it is Live
    if eb_event.status == eventbrite[:event_status_live]
      display = true

    # or if the event is Completed but a certain amount of days have not yet passed since the event's end_date
    elsif eb_event.status == eventbrite[:event_status_completed]
      end_time = Time.parse(eb_event.end_date)
      end_time = end_time.advance(:days => eventbrite[:num_days_to_display_event_after_completed])
      display = true if end_time >= Time.now
    end

    display
  end

  def setup_insights
    @total_indicated_decisions = Year.current.evaluate_stat(nil, stats_reports[:indicated_decisions_report][:indicated_decisions])

    if is_staff_somewhere
      my_campuses = @ministry.campuses
    else
      my_campuses = [@person.primary_campus]
      my_campuses ||= @my.campuses
    end

    if my_campuses.present?
      @campus_indicated_decisions = Year.current.evaluate_stat(my_campuses.collect{|c| c.id}, stats_reports[:indicated_decisions_report][:indicated_decisions])
      @insights_campuses = my_campuses
    else
      @campus_indicated_decisions = nil
    end
  end

  def setup_pat_stats
    @staff = @me.is_staff_somewhere?
    #@staff = false
    get_person_campuses
    campus_ids = CmtGeo.campuses_for_country("CAN").collect(&:id)
    @project_applying_totals_by_campus, @project_applying_totals_by_project = project_applying_totals(campus_ids)
    @project_accepted_totals_by_campus, @project_accepted_totals_by_project = project_acceptance_totals(campus_ids, @project_applying_totals_by_campus)
    @project_totals = projects_count_hash
    @interested_campuses = get_person_current_campuses
    @interested_campuses_abbrvs = @interested_campuses.collect(&:abbrv)
    if @staff
      @project_campuses = (@project_accepted_totals_by_campus.keys | @project_applying_totals_by_campus.keys | @interested_campuses_abbrvs)
    else
      @project_campuses = (@project_accepted_totals_by_campus.keys | @project_applying_totals_by_campus.keys) & @interested_campuses_abbrvs
    end
  end
end
