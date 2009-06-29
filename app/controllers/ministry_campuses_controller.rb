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
  		if params[:new_camp]
			flash[:notice] = "Campus switched"	
			show_id = params[:new_camp]
    else
			if params[:tree_head_id]
				#saves the new tree head
				@cur_min_camp = MinistryCampus.find_by_id(params[:id])
		@cur_min_camp.tree_head_id = params[:tree_head_id]
        @cur_min_camp.save
		flash[:notice] = @cur_min_camp.campus.name + "'s tree head was changed."
										
		# get everyone who is in this ministry campus
		get_min_camp_people
					
		# we now have everyone in this campus_ministry, lets start severing those
		# who are not under the new tree_head and are not connected to him
		@min_camp_people.each do |person|
					unless rp_by_head(person)
						if person.responsible_person
							cur_mi = person.ministry_involvements.find_by_ministry_id @ministry.id
							cur_mi.responsible_person_id = nil
							cur_mi.save
							#Should send a correspondence saying your RP must be reset
			end
					end
		end
      end
      show_id = params[:id]
        end
          
    respond_to do |format|
      format.js do
        render :update do |page|
          page.redirect_to (:action => 'show', :id => show_id)
          update_flash(page)
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
		@cur_min_camp = MinistryCampus.find_by_id params[:id]
    set_min_camps  
  end 
  
  protected 
  
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
    @possible_tree_heads = []
    if @cur_min_camp
      @cur_tree_head = @cur_min_camp.tree_head
      @cur_camp = @cur_min_camp.campus
      get_possible_tree_heads
    end
  end
  
  def get_min_camp_people
  	min_people = @ministry.people
    @min_camp_people = []
    min_people.each do |person|
         if @cur_min_camp.campus.people.find :first, :conditions => {:id => person.id}
      	@min_camp_people << person
      end
    end
  end
  
  
  def get_possible_tree_heads
    get_min_camp_people
    
    #Don't know why this doesn't accept people when I have cur_role_type == "StaffRole", even when it is equal to "StaffRole" Leave it here for now
    @min_camp_people.each do |person|
    cur_role_type = person.ministry_involvements.find(:first, :conditions => {:ministry_id => @ministry.id}).ministry_role.type
      if cur_role_type #== "StaffRole"
        @possible_tree_heads << person
      end
    end
  end
  
end
