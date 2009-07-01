class PromotionsController < ApplicationController
layout 'people'
before_filter :user_filter

	def index
		if params[:person_id]
			@person = Person.find_by_id params[:person_id]
		end
	end
	
		
	def update
		create = false
		unless params[:answer] #unless accepting or declines an actual request
			#first, find out where what ministry this person_responsible_for, since it might not necesarily be @ministry
			#to do that, find out what ministry_involvement connects these two people
			mi_looked_at = MinistryInvolvement.find_by_responsible_person_id_and_person_id(params[:person_id], params[:id])
			#then find that ministry_involvement's ministry
			ministry_looked_at = Ministry.find_by_id mi_looked_at.ministry_id
		
			#get our people and their ministry_roles in the ministry we are looking at
			@person = Person.find_by_id params[:person_id]
			to_promote = Person.find_by_id params[:id]
			person_role = @person.ministry_involvements.find_by_ministry_id(ministry_looked_at.id).ministry_role
			old_role = to_promote.ministry_involvements.find_by_ministry_id(ministry_looked_at.id).ministry_role
			if old_role.position > person_role.position
				new_role = MinistryRole.find_by_position(old_role.position - 1)
				if old_role.type == new_role.type	
					mi_looked_at.ministry_role_id = new_role.id
					mi_looked_at.save
					flash[:notice] = to_promote.full_name + " has been promoted"
					create = false
				else 
					create = true
					flash[:notice] = "A request has been sent to the head of the Responsible Person tree."
				end
			else
				flash[:notice] = to_promote.full_name + " can not be promoted any higher."
				create = false
			end
		else
			prom = Promotion.find_by_id params[:id]
			prom.answer = params[:answer]
			if params[:answer] == "accept"
				flash[:notice] = prom.person.full_name + " has been promoted."
				cur_role = prom.ministry_involvement.ministry_role
				next_role_id = MinistryRole.find_by_position(cur_role.position - 1).id
				prom.ministry_involvement.ministry_role_id = next_role_id
				prom.ministry_involvement.save
			else
				flash[:notice] = "Request declined."
			end
			prom.save	
		end
		respond_to do |format|
			if create
				#render :action => "create", :person_id => @person.id, :promotee_id => to_promote.id, :ministry_involvement_id => mi_looked_at.id
				create_promotion(to_promote.id, mi_looked_at.id)
			else 
				format.html {redirect_to person_promotions_path(@person)}
			end
      format.js do
        render :update do |page|
      	   update_flash(page)
      	end
      end
  	end
	end
	
	def destroy
		prom = Promotion.find_by_id params[:id]
		unless prom.nil?
			prom.destroy
			flash[:notice] = "Promotion deleted."
		end
		redirect_to :action => 'index', :person_id => @me.id
	end
	
	
	private
	
	def user_filter
		unless params[:person_id] && @person && @person == @me
			redirect_to :action => 'index', :person_id => @me.id
		end
	end
	
	def create_promotion(promotee_id = nil, ministry_involvement_id = nil)	
		#will try to send a request to the tree head of this person's ministry campus
		#if there is no tree head, then we will look for this person's responsible person's responsible person (two steps up the tree)
		#if this is not possible, we will look for the person with highest ministry role in that ministry.
		
		to_promote = Person.find_by_id promotee_id
		
		#Trying to find ministry_campus
		mi = MinistryInvolvement.find_by_id ministry_involvement_id
		most_recent_campus_involvement = to_promote.most_recent_involvement
		active_ministry_campus = MinistryCampus.find_by_campus_id_and_ministry_id most_recent_campus_involvement.campus_id,
																																						mi.ministry_id
		if active_ministry_campus.tree_head
			promoter_id = active_ministry_campus.tree_head_id
		elsif to_promote.responsible_person
			if to_promote.responsible_person.responsible_person
				promoter_id = to_promote.responsible_person.responsible_person.id
			end
		else
			## find someone with the highest ministry_role in that ministry
			active_ministry = Ministry.find_by_id mi.ministry_id
			stop = false
			count = 0
			while !stop
				count += 1
				#find the next highest MinistryRole
				cur_role = MinistryRoles.find_by_position(count)
				if cur_role
					#find a ministry_involvement with that role
					cur_mi = active_ministry.ministry_involvements.find(:first, :conditions => {:ministry_role_id => cur_role.id})
					if cur_mi
						promoter_id = cur_mi.person_id
						stop = true
					end
				else #we have gone through all the roles, this should NEVER happen, but just incase it does
					#have the person promote himself
					promoter_id = promotee_id
					stop = true
				end	
			end				
		end
		
		p = Promotion.new(:person_id => promotee_id,
																	:promoter_id => promoter_id, 
																	:ministry_involvement_id => ministry_involvement_id)	
		p.save
		
	end
	
end
