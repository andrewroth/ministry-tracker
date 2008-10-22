class TeamsController < GroupsController
  before_filter :get_team, :only => [:show, :edit, :destroy, :update]
  before_filter :team_admin
  def index
    @teams = @person.teams.find(:all, :group => _(:ministry_id, :group_involvement), 
                                                      :order => Ministry.table_name + '.' + _(:name, :ministry),
                                                      :include => :ministry)
    super
  end
  
  def new
    @team = Team.new
    super
  end
  
  def create
    @team = @group = Team.new(params[:team])
    super
  end
  
  def update
    # raise params.inspect
    @team.update_attributes(params[:team])
    super
  end
  
  def destroy
    @group = @team
    super
  end
  
  protected
    def get_team
      @team ||= get_group
    end
end