class TimetablesController < ApplicationController
  layout 'people'
  before_filter :get_timetable, :except => [:create, :index]
  # GET /timetables
  # GET /timetables.xml
  def index
    @timetables = Timetable.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @timetables }
    end
  end

  # GET /timetables/1
  # GET /timetables/1.xml
  def show
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
    logger.debug(@free_times[1].inspect)
      # raise @free_times[1].inspect
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @timetable }
    end
  end

  # GET /timetables/new
  # GET /timetables/new.xml
  def new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @timetable }
    end
  end

  # GET /timetables/1/edit
  # def edit
  #   @timetable = Timetable.find(params[:id])
  # end

  # POST /timetables
  # POST /timetables.xml
  def create
    @timetable = Timetable.new(params[:timetable])

    respond_to do |format|
      if @timetable.save
        flash[:notice] = 'Timetable was successfully created.'
        format.html { redirect_to(@timetable) }
        format.xml  { render :xml => @timetable, :status => :created, :location => @timetable }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @timetable.errors, :status => :unprocessable_entity }
      end
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
      if @timetable.update_attributes(params[:timetable])
        flash[:notice] = 'Timetable was successfully updated.'
        format.js
        format.html { redirect_to(@timetable) }
        format.xml  { head :ok }
      else
        format.js
        format.html { render :action => "edit" }
        format.xml  { render :xml => @timetable.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /timetables/1
  # DELETE /timetables/1.xml
  # def destroy
  #   @timetable = Timetable.find(params[:id])
  #   @timetable.destroy
  # 
  #   respond_to do |format|
  #     format.html { redirect_to(timetables_url) }
  #     format.xml  { head :ok }
  #   end
  # end
  
  protected
    def get_timetable
      @timetable = @person.timetable || Timetable.new(:person_id => @person.id)
    end
end
