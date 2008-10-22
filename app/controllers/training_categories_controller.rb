class TrainingCategoriesController < ApplicationController
  in_place_edit_for :training_category, :name
  layout 'manage'
  # GET /training_categories
  # GET /training_categories.xml
  def index
    @training_categories = @ministry.training_categories

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @training_categories }
    end
  end


  # GET /training_categories/new
  # GET /training_categories/new.xml
  def new
    @training_category = TrainingCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.js
      format.xml  { render :xml => @training_category }
    end
  end

  # GET /training_categories/1/edit
  def edit
    @training_category = TrainingCategory.find(params[:id])
  end

  # POST /training_categories
  # POST /training_categories.xml
  def create
    @training_category = @ministry.training_categories.new(params[:training_category])
    
    respond_to do |format|
      if @training_category.save
        flash[:notice] = 'Training Category was successfully created.'
        format.html { redirect_to(training_categories_path) }
        format.js
        format.xml  { render :xml => @training_category, :status => :created, :location => @training_category }
      else
        format.js   { render :action => "new" }
        format.html { render :action => "new" }
        format.xml  { render :xml => @training_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /training_categories/1
  # PUT /training_categories/1.xml
  def update
    @training_category = TrainingCategory.find(params[:id])

    respond_to do |format|
      if @training_category.update_attributes(params[:training_category])
        flash[:notice] = 'Training Category was successfully updated.'
        format.html { redirect_to(training_categories_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @training_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /training_categories/1
  # DELETE /training_categories/1.xml
  def destroy
    @training_category = TrainingCategory.find(params[:id])
    @training_category.destroy
    flash[:notice] = 'Training Category was successfully deleted.'

    respond_to do |format|
      format.html { redirect_to(training_categories_url) }
      format.xml  { head :ok }
      format.js
    end
  end
end
