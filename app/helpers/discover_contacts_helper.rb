module DiscoverContactsHelper

  def get_discover_feed_items(campuses, number_of_items = 10)
    activities = Activity.all(:conditions => { :reportable_type => 'Contact', :contacts => { :campus_id => campuses } },
                              :joins => 'LEFT JOIN contacts ON contacts.id = activities.reportable_id',
                              :include => [:reporter],
                              :order => 'created_at DESC',
                              :limit => number_of_items * 10)

    notes = Note.all(:conditions => { :noteable_type => 'Contact', :contacts => { :campus_id => campuses } },
                     :joins => 'LEFT JOIN contacts ON contacts.id = notes.noteable_id',
                     :include => [:person],
                     :order => 'created_at DESC',
                     :limit => number_of_items * 10)

    contacts = DiscoverContact.all(:conditions => { :campus_id => campuses },
                                   :include => [:people],
                                   :order => 'created_at DESC',
                                   :limit => number_of_items * 10)

    feed_objects = activities + notes + contacts

    feed = []
    feed_objects.each do |feed_object|
      feed << { :created_at => feed_object.created_at,
                :action => feed_item_action(feed_object),
                :object => feed_object,
                :priority => feed_item_priority(feed_object) }
    end

    # sort
    feed.sort! { |a, b| b[:created_at] <=> a[:created_at] }

    # filter feed items to make it more interesting
    filtered_items = []
    if feed.size <= number_of_items
      filtered_items = feed
    else
      feed.each_with_index do |feed_item, i|
        if filtered_items.last.blank?
          filtered_items << feed_item
          next
        end

        # if adjactent items actions are different
        if feed_item[:action] != filtered_items.last[:action]
          # if adjactent items people are different
          if feed_item[:object].person != filtered_items.last[:object].person
            filtered_items << feed_item unless filtered_items.last[:priority] < 2 && feed_item[:priority] < filtered_items.last[:priority]

          else # adjactent items people are the same
            if feed_item[:priority] > 6
              filtered_items.delete_at(-1) if feed_item[:priority] > filtered_items.last[:priority]
              filtered_items << feed_item
            end
          end

        # if adjactent items actions are the same
        elsif feed_item[:action] == filtered_items.last[:action]
          # if adjactent items people are different
          if feed_item[:object].person != filtered_items.last[:object].person
            filtered_items << feed_item if feed_item[:priority] > 3

          else # adjactent items people are the same
            if feed_item[:priority] > 8
              filtered_items.delete_at(-1) if feed_item[:priority] > filtered_items.last[:priority]
              filtered_items << feed_item
            end
          end
        end
      end
    end

    filtered_items[0..([filtered_items.size, number_of_items].min - 1)]
  end

  def feed_item_action(feed_object)
    case feed_object
    when Activity
      case feed_object.to_s
      when 'Spiritual Conversation'
        "had a #{feed_object}"
      when 'Gospel Presentation'
        "shared a #{feed_object}!"
      when 'Indicated Decision'
        "saw an #{feed_object}!"
      when 'Shared Spirit-filled life'
        "shared #{feed_object}"
      else
        "had an #{feed_object}"
      end
    when Note
      'wrote a note'
    when DiscoverContact
      'added a new contact'
    end
  end

  def feed_item_priority(feed_object)
    priority_action = case feed_object
    when Activity
      case feed_object.to_s
      when 'Indicated Decision'
        8
      when 'Gospel Presentation'
        6
      when 'Shared Spirit-filled life'
        5
      when 'Spiritual Conversation'
        4
      when 'Interaction'
        2
      else
        0
      end
    when Note
      1
    when DiscoverContact
      2
    else
      0
    end

    priority_time = case feed_object.created_at
    when (1.hour.ago)..(Time.now)
      4
    when (1.day.ago)..(Time.now)
      3
    when (1.week.ago)..(Time.now)
      2
    when (1.month.ago)..(Time.now)
      1
    else
      0
    end

    priority_action + priority_time
  end

  def feed_item_to_s(feed_item)
    %(#{link_to feed_item[:object].person, feed_item[:object].person} #{feed_item[:action]} &#8211; <em title="#{feed_item[:created_at]}">#{time_ago_in_words(feed_item[:created_at])} ago</em>)
  end

end