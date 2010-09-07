class InputSummit2010EventInfo < ActiveRecord::Migration

  NEW_EVENT_GROUPS = [{:title => "Summit 2010", :descripton => "Summit 2010"}]

  NEW_EVENTS = [{:registrar_event_id => "819968548", :event_group_title => NEW_EVENT_GROUPS[0][:title], :register_url => "http://whitepinesummit.eventbrite.com/", :campuses => [1, 51, 46, 56, 72]},
                {:registrar_event_id => "818040782", :event_group_title => NEW_EVENT_GROUPS[0][:title], :register_url => "http://umanitobasummit.eventbrite.com/", :campuses => [24]},
                {:registrar_event_id => "820115989", :event_group_title => NEW_EVENT_GROUPS[0][:title], :register_url => "http://albertasummit.eventbrite.com/", :campuses => [7, 8, 68, 67, 76]},
                {:registrar_event_id => "824882245", :event_group_title => NEW_EVENT_GROUPS[0][:title], :register_url => "http://oqsummit.eventbrite.com/", :campuses => [61, 73, 43, 53, 48]},
                {:registrar_event_id => "819954506", :event_group_title => NEW_EVENT_GROUPS[0][:title], :register_url => "http://maritimessummit.eventbrite.com/", :campuses => [37, 40, 83]},
                {:registrar_event_id => "824852155", :event_group_title => NEW_EVENT_GROUPS[0][:title], :register_url => "http://braesidesummit.eventbrite.com/", :campuses => [54, 57, 49, 2]}
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
