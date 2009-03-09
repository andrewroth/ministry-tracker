class TrainingQuestionsController < ApplicationController
  before_filter :get_training_question, :only => [:update, :destroy]
  
  def new
    @training_question = TrainingQuestion.new
    @training_question.ministry_id = @ministry.id
    @training_categories = @ministry.all_training_categories
  end
  
  def edit
    @training_question = TrainingQuestion.find(params[:id])
    @type = @training_question.class.to_s
    respond_to do |format|
      format.js 
    end
  end
  
  def create
    @training_question = TrainingQuestion.new(params[:training_question])
    @training_question.ministry = @ministry # Add bible study to current ministry
    # @attributes = @ministry.send(params[:type].underscore.pluralize)
    respond_to do |format|
      if @training_question.save
        flash[:notice] = @training_question.activity + ' was successfully created.'
        format.html { redirect_to training_questions_url }
        format.js   
        format.xml  { head :created, :location => training_questions_url(@training_question) }
      else
        format.html { render :action => "new" }
        format.js   { render :action => "new" }
        format.xml  { render :xml => @training_question.errors.to_xml }
      end
    end
  end
  
  def update
    @training_question.update_attributes(params[:training_question])
    respond_to do |format|
      format.js { render :template => 'training_questions/update' }
    end
  end

  def destroy
    @training_question.destroy 
    flash[:notice] = @training_question.activity + ' was successfully DELETED.'
    respond_to do |format|
      format.js 
    end
  end
  
  protected
    def get_training_question
      @training_question = TrainingQuestion.find(params[:id])
    end
end
