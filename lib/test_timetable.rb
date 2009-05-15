require 'pp'

@people = Person.find(:all, :conditions => ["id in (?)", [71110,50000,71296,66456,66361,66349,66241,66241,71387]])
timetables = {}
@people.each_with_index do |person, i|
  if person.free_times == []
    puts "no schedule for #{person.full_name}" 
  else
    timetables[person] = Timetable.setup_timetable(person)
  end
end
# 1.5 hour block
# 30 min intervals
# 3 blocks (round up)
num_blocks = 3
user_weights = []
midnight = Time.now.beginning_of_day
stop_time = midnight + Timetable::LATEST

possible_times = []
7.times do |day| 
  time = midnight + Timetable::EARLIEST 
  while time < stop_time 
    time_in_seconds = time.to_i - midnight.to_i 
    possible_times << {:time => time_in_seconds, :score => 0, :day => day}
    time += Timetable::INTERVAL
  end
end
@people.each_with_index do |person, i|
  user_weights[i] = 1.0 / @people.length
end

puts "Initial weights: \n#{user_weights.inspect}\n\n"
  
needed_groups = 3

top_times = Timetable.get_top_times(user_weights, timetables, num_blocks, needed_groups, possible_times, @people)

if needed_groups > 1
  groups = []
  top_times.each_with_index do |top_time, i|
    groups << [top_time]
    possible_times -= [top_time]
  end
end

# pp groups

(2..needed_groups).each do |i|
  # Otherwise, just go with the top pick and recurse from there
  groups.each_with_index do |group, gi|
    time = Timetable.get_top_times(group[i - 2][:user_weights], timetables, num_blocks, needed_groups, possible_times, @people, i)[0]
    possible_times -= [time]
    groups[gi] << time
  end
  # puts "Group #{i}:"
  # puts best_time.inspect
  # puts
  # possible_times.delete(best_time)
  # #update user weights
  # adjust_weights(best_time, user_weights, timetables, num_blocks)
  # puts "user weights: \n#{user_weights.inspect}\n\n"
end

groups.each_with_index do |group, i|
  puts "Options #{i + 1}"
  group.each do |time_slot|
    puts "#{time_slot[:day]} - #{time_slot[:time] / 60.0 / 60}: #{time_slot[:score]}"
  end
  puts
end
