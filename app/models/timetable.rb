
class Timetable < ActiveRecord::Base
  load_mappings
  
  # You can change any of these constants and have everything still work,
  # including existing timetables.
  EARLIEST = 6.hours.to_i
  LATEST = 22.hours.to_i
  INTERVAL = 30.minutes.to_i

  # Weights are for Dan Frett's algorithm, would be incorrect for AJ's alg
  # Current iteration only uses three states.
  BAD_WEIGHT = 0.0
  POOR_WEIGHT = 0.3
  OK_WEIGHT = 0.7
  GOOD_WEIGHT = 1.0
  
  BAD_CLASS = 'bad'
  POOR_CLASS = 'poor'
  OK_CLASS = 'ok'
  GOOD_CLASS = 'good'

  # defines how many top solutions to display following a 'find common times' search
  DISPLAY_TOP = 5
  
  belongs_to :person, :class_name => "Person", :foreign_key => _(:person_id)
  has_many :free_times, :class_name => "FreeTime", :foreign_key => _(:timetable_id, :free_time), :order => "#{_(:day_of_week, :free_times)}, #{_(:start_time, :free_times)}"
  
  # Question: This is coded very much like our old PHP code, should we define 
  # an object instead and hold these values within the object's instance variables?
  # Question: If we are not manipulating the data with this search, should it be
  # in the controller rather than model?
  def self.get_top_times(user_weights, timetables, num_blocks, needed_groups, possible_times, people, leader_ids, assigned = [], iteration = 1, scored_times = [])
    # if scored_times.empty?
      possible_times.each_with_index do |time_slot, i|
        time_slot[:score] = calculate_score(time_slot, user_weights, timetables, num_blocks, people, leader_ids)
        scored_times[i] = time_slot
      end
    # end
  
    best_slots = []
    scored_times.sort! {|a,b| a[:score] <=> b[:score]}.reverse!
    
    # If it's the first iteration, pick the top 5 to use from there
    # if iteration == 1
      scored_times.each_with_index do |time_slot, i|
        break if i >= Timetable::DISPLAY_TOP
        time_slot[:user_weights] = adjust_weights(time_slot, user_weights, timetables, num_blocks, people, leader_ids)
        people_weights = ActiveSupport::OrderedHash.new
        time_slot[:user_weights].each_with_index do |uw, i|
          people_weights[people[i].id] = uw
        end
        # time_slot[:user_weights] = people_weights
        ordered_people = people_weights.sort {|x, y| x[1] <=> y[1]}.collect {|pw| pw[0]}
        each_group = (people.length.to_f / needed_groups.to_f).floor
        if iteration == 1
          pick = each_group + (people.length % needed_groups) 
        else
          pick = each_group 
        end
        members = []
        # Pick a leader for this group
        ordered_people.each do |person|
          if leader_ids.include?(person) && !assigned.include?(person)
            members << ordered_people.delete(person)
            time_slot[:leaders] = [person]
            break
          end
        end
        ordered_people.each do |person|
          members << person unless leader_ids.include?(person) || assigned.include?(person) || members.include?(person)
          break if members.length == pick
        end
        # members += ordered_people[0..(pick - 1)]
        # Set the weight to 0 for all the members we just picked
        time_slot[:user_weights].each_with_index do |uw, i|
          time_slot[:user_weights][i] = members.include?(people[i].id) ? 0.0 : uw
        end
        # raise time_slot[:user_weights].inspect
        # logger.debug(members.collect {|id| Person.find(id)}.collect(&:full_name).inspect)
        time_slot[:members] = members
        time_slot[:assigned] = members + assigned
        best_slots << time_slot
      end
    # else
    
    # end
    best_slots
  end

  def self.setup_timetable(person)
    # Create a hash of free times for output rendering
    @free_times = [Hash.new, Hash.new, Hash.new, Hash.new, Hash.new, Hash.new, Hash.new]
    unless person.free_times.empty?
      person.free_times.each do |ft|
        ft.start_time.step((ft.end_time + (ft.end_time % Timetable::INTERVAL)) - Timetable::INTERVAL, Timetable::INTERVAL) do |time|
          @free_times[ft.day_of_week][time] =  ft
        end
      end
    end
    @free_times
  end
  
  def self.generate_compare_table(people)
    timetables = []
    comparison_map = [Array.new, Array.new, Array.new, Array.new, Array.new, Array.new, Array.new]
    people.each do |person|
      timetables << setup_timetable(person)
    end
    
    midnight = Time.now.beginning_of_day
    
    7.times do |day|
        time = midnight + Timetable::EARLIEST 
        stop = midnight + Timetable::LATEST 
        time_block = 0
        while time < stop 
          time_in_seconds = time.to_i - midnight.to_i
          
          goods = []
          bads = []
          okays = []
          poors = []
          timetables.each_with_index do |tt,i|
            css_class = (!tt[day][time_in_seconds].nil?) ? tt[day][time_in_seconds].css_class : ''
            if (css_class == GOOD_CLASS)
              goods << people[i]
            elsif (css_class == BAD_CLASS)
              bads << people[i]
            elsif (css_class == OK_CLASS)
              okays << people[i]
            elsif (css_class == POOR_CLASS)
              poors << people[i]
            end           
            
          end
          
          comparison_map[day] << {time_in_seconds => Hash.new }
          comparison_map[day][time_block][time_in_seconds]["goods"] = goods
          comparison_map[day][time_block][time_in_seconds]["bads"] = bads
          comparison_map[day][time_block][time_in_seconds]["okays"] = okays
          comparison_map[day][time_block][time_in_seconds]["poors"] = poors
          time += Timetable::INTERVAL 
          time_block += 1
        end  
        
    end
    comparison_map
  end

  def self.calculate_score(time_slot, user_weights, timetables, num_blocks, people, leader_ids)
    score = 0.0
    user_weights.each_with_index do |uw, person_index|
      score += get_user_score(time_slot, uw, timetables, num_blocks, people, person_index, leader_ids) 
    end
    return score
  end

  def self.get_user_score(time_slot, user_weight, timetables, num_blocks, people, person_index, leader_ids)
    user_score = user_weight
    (0..num_blocks).each do |block_offset|
      time = time_slot[:time] + (block_offset * Timetable::INTERVAL)
      unless time >= LATEST
        if timetables[people[person_index]][time_slot[:day]][time]
          time_score = timetables[people[person_index]][time_slot[:day]][time].weight.to_f
        else
          time_score = 0
        end
        user_score *= time_score #if time_score
      end
    end
    user_score
  end

  def self.get_user_adjustment_score(time_slot, user_weight, timetables, num_blocks, people, person_index, leader_ids)
    tmp_score = -1
    (0..num_blocks).each do |block_offset|
      time = time_slot[:time] + (block_offset * Timetable::INTERVAL)
      unless time >= LATEST
        if timetables[people[person_index]][time_slot[:day]][time].nil?
          time_score = OK_WEIGHT
        else
          time_score = timetables[people[person_index]][time_slot[:day]][time].weight.to_f
        end
        tmp_score *= time_score 
      end
    end
    user_weight * Math.exp(tmp_score)
  end

  def self.adjust_weights(best_time, user_weights, timetables, num_blocks, people, leader_ids)
    user_weights.each_with_index do |user_weight, index|
      user_weights[index] = get_user_adjustment_score(best_time, user_weight, timetables, num_blocks, people, index, leader_ids) 
    end

    # normalize weights so sum_of(uw) = 1
    # if the weights are all zero (because all the members have been assigned), reset to default weights
    if user_weights.sum == 0
      user_weights.each_with_index do |user_weight, index|
        user_weights[index] = 1.0 / people.length
      end
    end
    factor = 1 / user_weights.sum
    # puts factor
    # puts user_weights.sum
    user_weights.each_with_index do |w, i|
      user_weights[i] = w * factor
    end
  end
  
  def self.initialize_timetable(person)
    person.timetable ||= Timetable.new
    (0..6).each do |i|
      person.timetable.free_times.create(:start_time => EARLIEST, :end_time => LATEST, :day_of_week => i, :weight => OK_WEIGHT, :css_class => OK_CLASS) 
    end
  end
end
