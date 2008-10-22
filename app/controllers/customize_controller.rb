class CustomizeController < ApplicationController
  layout 'manage'
  def show
     # @ministry = Ministry.find(session[:ministry_id])
     @views = @ministry.views.find(:all, :order => _(:title, :view))
     @training_categories = @ministry.training_categories
  end
  
  def reorder_training_categories
    @view = Ministry.find(params[:id], :include => :training_categories)
    @view.training_categories.each do |category|
      category.position = params['training_categories_list'].index(category.id.to_s) + 1
      category.save
    end
    # delete_cache(@view.id)
    render :nothing => true
  end
end
