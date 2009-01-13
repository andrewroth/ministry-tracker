require 'json'
class TimetablesController < ApplicationController
  layout 'people'
  before_filter :get_timetable, :except => [:create, :index]
  before_filter :setup_timetable, :only => [:show, :edit]


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
    # There's an array for each day of the week
    times.each_with_index do |day, i|
      # Each day of the week then has a list of blocks
      day.each_with_index do |block, j|
        unless block.empty?
          # Each block then has a start time and an end time for a busy block
          # We need to convert this into a "free" block
          if block == day.first && block[0] != Timetable::EARLIEST
            @timetable.free_times.create(:start_time => Timetable::EARLIEST, :end_time => block[0], :day_of_week => i) 
          else
            free_start = block == day.first ? Timetable::EARLIEST : day[j - 1][1]
            free_end = day[j][0]
            @timetable.free_times.create(:start_time => free_start, :end_time => free_end, :day_of_week => i) unless block.empty?
          end
          if block == day.last
            @timetable.free_times.create(:start_time => block[1], :end_time => Timetable::LATEST, :day_of_week => i) unless block.empty?
          end
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
          @free_times[ft.day_of_week] << time
        end
        # We don't want the end time in the array
        @free_times[ft.day_of_week].pop
      end
    end
end
