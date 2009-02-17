class Timetable < ActiveRecord::Base
  load_mappings
  
  EARLIEST = 6.hours.to_i
  LATEST = 22.hours.to_i
  INTERVAL = 30.minutes.to_i
  DISPLAY_TOP = 5
  
  belongs_to :person, :class_name => "Person", :foreign_key => _(:person_id)
  has_many :free_times, :class_name => "FreeTime", :foreign_key => _(:timetable_id, :free_time), :order => "#{_(:day_of_week, :free_times)}, #{_(:start_time, :free_times)}"
  
  def self.get_top_times(user_weights, timetables, num_blocks, needed_groups, possible_times, people, iteration = 1, scored_times = [])
    # if scored_times.empty?
      possible_times.each_with_index do |time_slot, i|
        time_slot[:score] = calculate_score(time_slot, user_weights, timetables, num_blocks, people)
        scored_times[i] = time_slot
      end
    # end
  
    best_slots = []
    scored_times.sort! {|a,b| a[:score] <=> b[:score]}.reverse!
    
    # If it's the first iteration, pick the top 5 to use from there
    # if iteration == 1
      scored_times.each_with_index do |time_slot, i|
        break if i >= Timetable::DISPLAY_TOP
        time_slot[:user_weights] = adjust_weights(time_slot, user_weights, timetables, num_blocks, people)
        best_slots << time_slot
      end
    # else
    
    # end
    best_slots
  end

  def self.setup_timetable(person)
    # Create a hash of free times for outut rendering
    @free_times = [Hash.new, Hash.new, Hash.new, Hash.new, Hash.new, Hash.new, Hash.new]
    person.free_times.each do |ft|
      ft.start_time.step((ft.end_time + (ft.end_time % Timetable::INTERVAL)) - Timetable::INTERVAL, Timetable::INTERVAL) do |time|
        # weight = ft.css_class.present? ? ft.weight : 1
        @free_times[ft.day_of_week][time] =  ft
      end
      # We don't want the end time in the array
      # @free_times[ft.day_of_week].pop
    end
    @free_times
  end

  def self.calculate_score(time_slot, user_weights, timetables, num_blocks, people)
    score = 0.0
    user_weights.each_with_index do |uw, person_index|
      score += get_user_score(time_slot, uw, timetables, num_blocks, people, person_index) 
    end
    return score
  end

  def self.get_user_score(time_slot, user_weight, timetables, num_blocks, people, person_index)
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

  def self.get_user_adjustment_score(time_slot, user_weight, timetables, num_blocks, people, person_index)
    tmp_score = -1
    (0..num_blocks).each do |block_offset|
      time = time_slot[:time] + (block_offset * Timetable::INTERVAL)
      unless time >= LATEST
        time_score = timetables[people[person_index]][time_slot[:day]][time].weight.to_f
        tmp_score *= time_score #if time_score
      end
    end
    user_weight * Math.exp(tmp_score)
  end

  def self.adjust_weights(best_time, user_weights, timetables, num_blocks, people)
    user_weights.each_with_index do |user_weight, index|
      user_weights[index] = get_user_adjustment_score(best_time, user_weight, timetables, num_blocks, people, index) 
    end

    # normalize weights so sum_of(uw) = 1
    raise user_weights.inspect if user_weights.sum == 0
    factor = 1 / user_weights.sum
    # puts factor
    # puts user_weights.sum
    user_weights.each_with_index do |w, i|
      user_weights[i] = w * factor
    end
  end
end
