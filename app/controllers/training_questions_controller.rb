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
    @training_question.ministry = @ministry 
    respond_to do |format|
      if @training_question.save
        activate_question
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
    if params[:activate]
      if params[:activate] == '1'
        activate_question
      else
        deactivate_question
      end
    end
    if params[:mandate]
      if params[:mandate] == '1'
        activate_question(true)
      else
        activate_question(false)
      end
    end
    @training_question.update_attributes(params[:training_question]) if params[:training_question]
    respond_to do |format|
      format.js { render :template => 'training_questions/update' }
    end
  end

  def destroy
    if authorized?(:new, :training_questions, @training_question.ministry)
      deactivate_question
      # Check to see if any other ministry is using this question before actually deleting it
      if @training_question.training_question_activations.empty?
        @training_question.destroy
        flash[:notice] = @training_question.activity + ' was successfully DELETED.'
        respond_to do |format|
          format.js 
        end
      else
        flash[:warning] = @training_question.activity + ' is in use by other ministries. It has been deactivated, but cannot be deleted as long as other people are using it.'
        respond_to do |format|
          format.js { render :action => :update }
        end
      end
    else
      respond_to do |format|
        format.js { render :nothing => true}
      end
    end
  end
  
  protected
    def get_training_question
      @training_question = TrainingQuestion.find(params[:id])
    end
    
    def activate_question(mandate = false)
      unless @ministry.active_training_questions.include?(@training_question)
        tqa = TrainingQuestionActivation.new(:mandate => mandate)
        tqa.ministry = @ministry
        tqa.training_question = @training_question
        tqa.save!
      else
        tqa = TrainingQuestionActivation.find(:first, :conditions => {_(:ministry_id, :training_question_activation) => @ministry.id, 
                                                                    _(:training_question_id, :training_question_activation) => @training_question.id })
        tqa.update_attribute(:mandate, mandate)
      end
      tqa
    end
    
    def deactivate_question
      tqa = TrainingQuestionActivation.find(:first, :conditions => {_(:ministry_id, :training_question_activation) => @ministry.id, 
                                                                    _(:training_question_id, :training_question_activation) => @training_question.id })
      tqa.destroy if tqa
    end
end
