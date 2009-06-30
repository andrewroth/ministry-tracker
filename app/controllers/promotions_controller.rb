class PromotionsController < ApplicationController
layout 'people'

def index
	if params[:person_id]
		@person = Person.find_by_id params[:person_id]
	end
end

end
