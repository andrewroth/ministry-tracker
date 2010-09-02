# Provides the following information:
# * Count of people in ministry
# * movement count (definition unclear)
# * names of newest people added
class DashboardController < ApplicationController
  include SemesterSet
  before_filter :set_current_and_next_semester

  def index
    @people_in_ministries = MinistryInvolvement.count(:conditions => ["#{_(:ministry_id, :ministry_involvement)} IN(?)", @ministry.id ])
    @movement_count = @my.ministry_involvements.length
  
    @ministry_ids ||= @my.ministry_involvements.collect(&:ministry_id).join(',')
      
    if  @ministry_ids.present? #&& @ministry.campus_ids.present? 
       @newest_people = Person.find(:all, :conditions => "#{MinistryInvolvement.table_name}." + _(:ministry_id, :ministry_involvement) + " IN (#{@ministry_ids})", # OR #{CampusInvolvement.table_name}.#{_(:campus_id, :campus_involvement)} IN (#{@ministry.campus_ids.join(',')})
                                         :order => "#{Person.table_name}.#{_(:created_at, :person)} desc", :limit => 4, :joins => [:ministry_involvements, :campus_involvements])


      if Event.first.present?

        my_campuses_ids = get_ministry.unique_campuses.collect { |c| c.id }

        unless my_campuses_ids.empty? then
          my_event_ids = EventCampus.find(:all, :conditions => _(:campus_id, :event_campuses) + " IN (#{my_campuses_ids.join(',')})").collect { |ec| ec.event_id }
        end

        unless my_event_ids.empty? || my_campuses_ids.empty? then

          my_events = Event.find(:all, :conditions => "#{Event.table_name}." + _(:id, :event) + " IN (#{my_event_ids.join(',')})")

          @eventbrite_events = []
          live_event_ids = [] # get only the event_ids for live events, right now we get the event status from Eventbrite

          EventBright.setup(EventBright::KEYS[:api], true)
          @eventbrite_user = EventBright::User.new(EventBright::KEYS[:user])

          my_events.each do |event|
            eb_event = EventBright::Event.new(@eventbrite_user, {:id => event.eventbrite_id})

            if eb_event.status == "Live" then
              if my_campuses_ids.size == 1 && event.campuses.size > 1 then
                attendees = event.all_attendees_from_campus(Campus.find(my_campuses_ids.first))
                eb_event.attributes[:my_campus_num_attendees] = attendees.size
                @my_campus = Campus.find(my_campuses_ids[0])
              end

              @eventbrite_events << eb_event
              live_event_ids << event.id
            end
          end

          unless live_event_ids.empty? then
            #find all event_groups that the live events are in
            event_group_ids = Event.find(:all, :conditions => "#{Event.table_name}." + _(:id, :event) + " IN (#{live_event_ids.join(',')})").collect { |e| e.event_group_id }
            @event_groups = EventGroup.find(:all, :conditions => "#{EventGroup.table_name}." + _(:id, :event_group) + " IN (#{event_group_ids.join(',')})")
          end

        end

      end

    end

  end
  
end
