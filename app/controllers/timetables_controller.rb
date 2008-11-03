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
    # Create a hash of busy times for outut rendering
    @busy_times = [Array.new,Array.new,Array.new,Array.new,Array.new,Array.new,Array.new]
    @person.busy_times.each do |bt|
      # @busy_times[bt.day_of_week] << bt.start_time
      bt.start_time.step(bt.end_time, 15.minutes) do |time|
        @busy_times[bt.day_of_week] << time
      end
      @busy_times[bt.day_of_week].pop
    end
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
    @timetable.busy_times.destroy_all
    times = JSON::Pure::Parser.new(params[:times]).parse
    # There's an array for each day of the week
    times.each_with_index do |day, i|
      # Each day of the week then has a list of blocks
      day.each do |block|
        # Each block then has a start time and an end time
        @timetable.busy_times.create(:start_time => block[0], :end_time => block[1], :day_of_week => i) unless block.empty?
      end
    end
    # raise @times[0].inspect
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
