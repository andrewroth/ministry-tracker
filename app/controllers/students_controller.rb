class StudentsController < PeopleController
  layout 'manage'
  def new
    params[:student] = true
    super
  end
end
