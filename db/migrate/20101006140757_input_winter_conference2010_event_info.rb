class InputWinterConference2010EventInfo < ActiveRecord::Migration

  NEW_EVENT_GROUPS = [{:title => "Winter Conference 2010", :descripton => "Winter Conference 2010"}]

  NEW_EVENTS = [{:registrar_event_id => "831469949", :event_group_title => NEW_EVENT_GROUPS[0][:title], :register_url => "http://wcwest2010.eventbrite.com/", :campuses => [7,8,14,19,24,67,68,76,85,88,87]},
                {:registrar_event_id => "888847567", :event_group_title => NEW_EVENT_GROUPS[0][:title], :register_url => "http://wceast2010.eventbrite.com/", :campuses => [1,2,37,40,43,46,48,49,51,53,54,55,56,57,61,62,63,64,65,72,73,74,75,77,80,83,84,141,87,141]}
               ]


  def self.up

    NEW_EVENT_GROUPS.each do |group|
      EventGroup.create!(:title => group[:title], :description => group[:description]) if EventGroup.first(:conditions => {:title => group[:title], :description => group[:description]}).nil?
    end

    NEW_EVENTS.each do |event|

      if Event.find(:all, :conditions => {:registrar_event_id => event[:registrar_event_id]}).empty?
        Event.create!({ :registrar_event_id => event[:registrar_event_id],
                        :event_group_id => EventGroup.first(:conditions => {:title => event[:event_group_title]}).id,
                        :register_url => event[:register_url] })
      end

      new_event = Event.first(:conditions => {:registrar_event_id => event[:registrar_event_id]})

      event[:campuses].each do |campus_id|
        if EventCampus.find(:all, :conditions => {:event_id => new_event.id, :campus_id => campus_id}).empty?
          EventCampus.create!({ :event_id => new_event.id, :campus_id => campus_id })
        end
      end
    end

  end

  def self.down

    NEW_EVENTS.each do |event|

      e = Event.first(:conditions => {:registrar_event_id => event[:registrar_event_id]})

      event[:campuses].each do |campus_id|
        ec = EventCampus.first(:conditions => {:campus_id => campus_id, :event_id => e.id})
        ec.destroy unless ec.nil?
      end

      e.destroy unless e.nil?

    end

    NEW_EVENT_GROUPS.each do |group|
      eg = EventGroup.first(:conditions => {:title => group[:title], :description => group[:description]} )
      eg.destroy unless eg.nil?
    end

  end
end
