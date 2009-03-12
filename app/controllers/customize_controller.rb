class CustomizeController < ApplicationController
  layout 'manage'
  def show
     # @ministry = Ministry.find(session[:ministry_id])
     @views = @ministry.views.find(:all, :order => _(:title, :view))
     @training_categories = @ministry.training_categories
  end
  
  def reorder_training_categories
    @ministry = Ministry.find(params[:id], :include => :training_categories)
    @ministry.training_categories.each do |category|
      category.position = params['training_categories_list'].index(category.id.to_s) + 1
      category.save
    end
    render :nothing => true
  end
  
  def reorder_training_questions
    @category = TrainingCategory.find(params[:id], :include => :training_questions)
    @category.training_questions.each do |question|
      question.position = params["direct_training_questions_#{@category.id}"].index(question.id.to_s) + 1
      question.save
    end
    render :nothing => true
  end
end
