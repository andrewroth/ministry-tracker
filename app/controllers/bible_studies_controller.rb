class BibleStudiesController < GroupsController
  before_filter :get_bible_study, :only => [:show, :edit, :destroy, :update]
  before_filter :authorized?, :only => [:create, :update, :destroy]
  def index
    @bible_studies = @person.bible_studies.find(:all, :group => _(:ministry_id, :group_involvement), 
                                                      :order => Ministry.table_name + '.' + _(:name, :ministry),
                                                      :include => :ministry)
    super
  end
  
  def new
    @bible_study = BibleStudy.new
    super
  end
  
  def create
    @bible_study = @group = BibleStudy.new(params[:bible_study])
    super
  end
  
  def update
    @bible_study.update_attributes(params[:bible_study])
    super
  end
  
  def destroy
    @group = @bible_study
    super
  end
  
  protected
    def get_bible_study
      @bible_study ||= get_group
    end
end