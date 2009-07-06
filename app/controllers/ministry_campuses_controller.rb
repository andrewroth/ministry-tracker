class MinistryCampusesController < ApplicationController
  before_filter :get_countries
  skip_before_filter :get_ministry, :only => :index
  layout 'manage'
  
  def index
    @ministry = Ministry.find(session[:ministry_id])
    respond_to do |format|
      format.html
      format.js 
    end
  end
  
  def list
    @ministry = Ministry.find(params[:ministry_id])
    respond_to do |wants|
      wants.js
    end
  end
  
  def new
    get_countries
    @ministry = Ministry.find(params[:ministry_id])
  end
  
  def create
    respond_to do |format|
      begin
        @campus = Campus.find(params[:campus_id])
        # Add campus to ministry
        @ministry = Ministry.find(params[:ministry_id])
        @ministry_campus = MinistryCampus.create(_(:campus_id, 'ministry_campus') => params[:campus_id],
                                              _(:ministry_id, 'ministry_campus') => @ministry.id)
                                              
        @states = State.all()
        @campuses = Campus.find_all_by_country(params[:country_id], :order => 'name') if @states.nil? 
        flash[:notice] = @campus.name + ' was successfully added.'
        format.html { redirect_to address_url(@address) }
        format.js 
        format.xml  { head :created, :location => address_url(@address) }
        rescue ActiveRecord::StatementInvalid
        flash[:warning] = "You can't add the same campus to your ministry twice."
        format.html { render :action => "new" }
        format.js   do 
          render :update do |page|
            update_flash(page)
          end
        end
        format.xml  { render :xml => @address.errors.to_xml }
      end
    end
  end
  
  def update
  	get_ministry
		@cur_min_camp = MinistryCampus.find_by_id params[:id]
		if @cur_min_camp.ministry != @ministry
			@cur_min_camp = MinistryCampus.find(:first, :conditions => {:ministry_id => @ministry.id})
			show_id = @cur_min_camp.id
    elsif params[:new_camp]
			flash[:notice] = "Campus switched"
			@cur_min_camp = MinistryCampus.find_by_id params[:new_camp]	
			show_id = params[:new_camp]
    else
			if params[:tree_head_id]
				#saves the new tree head
		    @cur_min_camp.tree_head_id = params[:tree_head_id]
        @cur_min_camp.save
		    flash[:notice] = @cur_min_camp.campus.name + "'s tree head was changed."
										
		    # get everyone who is in this ministry campus
		    get_min_camp_people
					
		    # we now have everyone in this campus_ministry, lets start severing those
		    # who are not under the new tree_head and are not connected to him
		    @min_camp_people.each do |person|
					unless rp_by_head(person)
						cur_mi = person.ministry_involvements.find_by_ministry_id @ministry.id
						cur_mi.responsible_person_id = nil
						cur_mi.save
						#Should send a correspondence saying your RP must be reset
					end
		    end
      end
      show_id = false
    end   
    set_min_camps   
    respond_to do |format|
      format.js do
        render :update do |page|
        	update_flash(page)
        	if show_id
          	page.redirect_to(:action => 'show', :id => show_id)
          else
          	page.replace_html "tree_and_info", :partial => "report"
          end
        end
      end
    end
  end
  
  def destroy
    @ministry_campus = MinistryCampus.find(params[:id])
    @campus = @ministry_campus.campus
    @ministry_campus.destroy

    respond_to do |format|
      format.js  do
        render :update do |page|
          page.remove dom_id(@ministry_campus)
        end
      end
      format.xml  { head :ok }
    end
  end
  
  
  def show
  	get_ministry
		@cur_min_camp = MinistryCampus.find_by_id params[:id]
		if @cur_min_camp.ministry != get_ministry
			redirect_to :action => 'show', :id => MinistryCampus.find(:first, :conditions => {:ministry_id => @ministry.id}).id
		end			
    set_min_camps  
  end   
  
  
  
  
  
  private
  
  def rp_by_head(person = nil)
  	if person.responsible_person
		  if person.responsible_person == @cur_min_camp.tree_head
				true
		  else
				rp_by_head(person.responsible_person)
			end
		else
		  false
	  end
	end
	
  def set_min_camps
    if @cur_min_camp
      @cur_tree_head = @cur_min_camp.tree_head
      @cur_camp = @cur_min_camp.campus
      get_possible_tree_heads
      @no_rp = []
      @min_camp_people.each do |person|
      	unless @cur_min_camp.tree_head == person || person.ministry_involvements.find(:first, :conditions => ["responsible_person_id"])
      		@no_rp << person
      	end
      end
    end
  end
  
  def get_possible_tree_heads
  	@possible_tree_heads = []
    get_min_camp_people
    @min_camp_people.each do |person|
    cur_role_class = person.ministry_involvements.find(:first, :conditions => {:ministry_id => @ministry.id}).ministry_role.class
      if cur_role_class == StaffRole
        @possible_tree_heads << person
      end
    end
  end
  
  def get_min_camp_people
  
  #the commented code below works for the most part, but there is a bug in campus_involvements, that a new one isn't created
  #if a new ministry is made, and the user already has an involvement with that campus, but not with that ministry_campus,
  #so when that is fixed, uncomment this code and comment out the bad code below...or just delete it.
  
  #involvements = @cur_min_camp.campus.campus_involvements.find_all_by_ministry_id @cur_min_camp.ministry_id
  #@min_camp_people = []
  #involvements.each do |inv|
  	#@min_camp_people << inv.person
  #end
  
    #bad version starts here
  	min_people = @ministry.people
   	@min_camp_people = []
    min_people.each do |person|
    	if person.campuses.find_by_id @cur_min_camp.campus_id
      	@min_camp_people << person
      end
    end
    #bad version ends here    
  end  
end
