require 'json'
class TimetablesController < ApplicationController
  layout 'people'
  before_filter :get_timetable, :except => [:create, :index]
  before_filter :setup_timetable, :only => [:show, :edit]

  def index
    render :layout => 'manage'
  end

  # GET /timetables/1
  # GET /timetables/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @timetable }
    end
  end

  # PUT /timetables/1
  # PUT /timetables/1.xml
  def update
    # Clear out all other blocks
    @timetable.free_times.destroy_all
    times = JSON::Parser.new(params[:times]).parse
    # raise times.inspect
    # There's an array for each day of the week
    times.each_with_index do |day, i|
      # Each day of the week then has a list of blocks
      day.each_with_index do |block, j|
        unless block.empty?
          # Each block has a start time and an end time for a free block
          @timetable.free_times.create(:start_time => block[0], :end_time => block[1], :day_of_week => i, :weight => block[2], :css_class => block[3]) 
        end
      end
    end

    respond_to do |format|
      flash[:notice] = 'Timetable was successfully updated.'
      format.html { redirect_to(person_timetable_path(@timetable.person, @timetable)) }
      format.js
      format.xml  { head :ok }
    end
  end
  
  def search
    person_ids = []
    person_ids += params[:member_ids] if params[:member_ids]
    person_ids += params[:leader_ids] if params[:leader_ids]
    person_ids += params[:co_leader_ids] if params[:co_leader_ids]
    unless person_ids.empty?
      @people = Person.find(:all, :conditions => ["id in (?)",  person_ids])
      timetables = {}
      @no_timetable = []
      @people.each_with_index do |person, i|
        if person.free_times == []
          @no_timetable << person
        else
          timetables[person] = Timetable.setup_timetable(person)
        end
      end
      @people -= @no_timetable
      unless @people.empty?
        num_blocks = 1.hour / Timetable::INTERVAL
        user_weights = []
        midnight = Time.today.beginning_of_day
        stop_time = midnight + (Timetable::LATEST - (Timetable::INTERVAL * num_blocks))
    
    
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

        logger.debug "Initial weights: \n#{user_weights.inspect}\n\n"
  
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
        end

        groups.each_with_index do |group, i|
          logger.debug "Options #{i + 1}"
          group.each do |time_slot|
            logger.debug "#{time_slot[:day]} - #{time_slot[:time] / 60.0 / 60}: #{time_slot[:score]}"
          end
        end
        @groups = groups
      end
    end
    respond_to do |wants|
      wants.js  do
        render :update do |page|
          page[:results].replace_html :partial => 'possible_times'
          page[:results].show
          page[:spinnersubmit].hide
        end
      end
    end
  end
  
  protected
    def get_timetable
      @timetable = @person.timetable || Timetable.new(:person_id => @person.id)
      @person.timetable ||= @timetable
    end
    
    def setup_timetable
      # Create a hash of free times for outut rendering
      @free_times = [Array.new, Array.new, Array.new, Array.new, Array.new, Array.new, Array.new]
      @person.free_times.each do |ft|
        # @free_times[bt.day_of_week] << bt.start_time
        ft.start_time.step(ft.end_time + (ft.end_time % Timetable::INTERVAL), Timetable::INTERVAL) do |time|
          css_class = ft.css_class.present? ? ft.css_class : 'good'
          @free_times[ft.day_of_week] << {time => css_class}
        end
        # We don't want the end time in the array
        @free_times[ft.day_of_week].pop
      end
      # raise @free_times.inspect
    end
end
