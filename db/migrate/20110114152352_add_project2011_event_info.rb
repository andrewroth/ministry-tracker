class AddProject2011EventInfo < ActiveRecord::Migration

  NEW_EVENT_GROUPS = [{:title => "Project", :description => "Project"}]

  NEW_EVENTS = [{:registrar_event_id => "893920741", :event_group_title => NEW_EVENT_GROUPS[0][:title], :register_url => "http://projectreg2011.eventbrite.com/",
                 :campuses => [72, 43, 76, 73, 37, 74, 84, 61, 46, 75, 87, 48, 70, 49, 40, 77, 14, 80, 88, 62, 64, 63, 65, 7, 19, 8, 51, 24, 83, 141, 53, 67, 68, 54, 85, 1, 2, 55, 56, 57]}
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
