class StaffController < PeopleController
  layout 'manage'
  
  def index
    @staff = @ministry.staff
  end
  
  def new
    params[:staff] = true
    super
  end
  
  def demote
    @person = Person.find(params[:id])
    # we have to have at least one campus for this person
    if params[:campus] || @person.campus_involvements.count > 0
      # also make sure they're not a staff person
      @mi = MinistryInvolvement.find_by_ministry_id_and_person_id(@ministry.id, @person.id) 
      @mi.destroy if @mi
      # create campus involvement
      @person.add_campus(params[:campus], @ministry.id, @me.id)
    end
  end
  
  def demote_form
    @staff = Person.find(params[:id])
  end
  
end