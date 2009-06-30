class PromotionsController < ApplicationController
layout 'people'
before_filter :user_filter

	def index
		if params[:person_id]
			@person = Person.find_by_id params[:person_id]
		end
	end

	def update
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
			mi_looked_at.ministry_role_id = MinistryRole.find_by_position(old_role.position - 1).id
			mi_looked_at.save
			flash[:notice] = to_promote.full_name + " has been promoted"
		else
			flash[:notice] = to_promote.full_name + " can not be promoted any higher."
		end
		respond_to do |format|
      format.js do
        render :update do |page|
          page.redirect_to (:action => 'index', :person_id => @person.id)
          update_flash(page)
        end
      end
    end
	end
	
	private
	
	def user_filter
		unless params[:person_id] && @person && @person == @me
			redirect_to :action => 'index', :person_id => @me.id
		end
	end

	

end
