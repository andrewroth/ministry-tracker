# Question: I believe views are customisable, this would be their CRUD
class ViewsController < ApplicationController
  in_place_edit_for :view, :title
  layout 'manage'
  # GET /views
  # GET /views.xml
  def index
    @views = @ministry.views.find(:all, :order => _(:title, :view))

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @views.to_xml }
    end
  end

  # GET /views/new
  def new
    @view = View.new
  end

  # GET /views/1;edit
  def edit
    @view = View.find(params[:id])
    column_ids = @view.view_columns.collect(&:column_id)
    column_ids << 0
    @columns = Column.find(:all, :conditions => _(:id, :column) + " NOT IN (" + column_ids.join(',') + ")", :order => 'title')
    
    # Make this view the current view
    session[:view_id] = @view.id
  end

  # POST /views
  # POST /views.xml
  def create
    @view = View.new(params[:view])
    @view.ministry = @ministry

    respond_to do |format|
      if @view.save
        # Make this view the current view
        session[:view_id] = @view.id
        flash[:notice] = 'View was successfully created.'
        format.html { redirect_to edit_view_url(@view) }
        format.xml  { head :created, :location => view_url(@view) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @view.errors.to_xml }
      end
    end
  end
  
  def reorder
    @view = View.find(params[:id], :include => :view_columns)
    @view.view_columns.each do |view_column|
      view_column.position = params['column_list'].index(view_column.id.to_s) + 1
      view_column.save
    end
    # delete_cache(@view.id)
    render :nothing => true
  end
  
  # default view
  def set_default
    @view = View.find(params[:id])
    respond_to do |format|
      @view.update_attributes(params[:view])
      # There can only be one default view
      @ministry.views.each do |view|
        view.update_attribute(:default_view, false) unless view == @view
      end
      format.js
    end
  end
  
  # PUT /views/1
  # PUT /views/1.xml
  def update
    @view = View.find(params[:id])

    respond_to do |format|
      if @view.update_attributes(params[:view])
        # There can only be one default view
        if params[:view][:default_view]
          @ministry.views.each do |view|
            view.update_attribute(:default_view, false) unless view == @view
          end
        end
        flash[:notice] = 'View was successfully updated.'
        format.html { redirect_to views_url }
        format.xml  { head :ok }
        format.js
      else
        edit
        format.html { render :action => "edit" }
        format.xml  { render :xml => @view.errors.to_xml }
        format.js
      end
    end
  end
  
  # DELETE /views/1
  # DELETE /views/1.xml
  def destroy
    @view = View.find(params[:id])
    if @view.ministry.views.count > 1
      @view.destroy

      respond_to do |format|
        format.html { redirect_to views_url }
        format.xml  { head :ok }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to views_url }
        format.xml  { head :ok }
        format.js   do 
          render :update do |page|
            page.alert('You must leave at least one view defined')
            page.hide('spinnerview')
          end
        end
      end
    end
  end
end
