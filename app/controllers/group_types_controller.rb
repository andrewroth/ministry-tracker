# CRUD for group types of a given ministry 

class GroupTypesController < ApplicationController
  layout 'manage'
  before_filter :find_group_type, :only => [:edit, :update, :destroy]
    
  # GET /group_types
  # GET /group_types.xml
  def index
    # find all group types belonging to your ministry
    @group_types = @ministry.group_types
    pageTitle = "Group Type Editor"
    respond_to do |format|
      layout = 'manage'
      format.xml  { render :xml => @group_types }
    end
  end


  # GET /group_types/new
  # GET /group_types/new.xml
  def new
    @group_type = GroupType.new
  end

  # GET /group_types/1/edit
  def edit
  end


  # POST /group_types
  # POST /group_types.xml
  def create
    @group_type = GroupType.new(params[:group_type])
    @group_type.ministry = get_ministry
    
    if @group_type.save
      render
    else
      render :action => :new
    end
  end
  
  

  # PUT /group_types/1
  # PUT /group_types/1.xml
  def update

    respond_to do |format|
      if @group_type.update_attributes(params[:group_type])
        flash[:notice] = 'GroupType was successfully updated.'
        format.html { redirect_to(group_types_path) }
        format.xml  { head :ok }
        format.js
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group_type.errors, :status => :unprocessable_entity }
        format.js   { render :action => 'edit'}
      end
    end
  end

  # DELETE /group_types/1
  # DELETE /group_types/1.xml
  def destroy
    @group_type.destroy

    respond_to do |format|
      format.html { redirect_to(group_types_url) }
      format.xml  { head :ok }
      format.js
    end
  end
  
  protected
  def find_group_type
    @group_type = @ministry.group_types.find(params[:id])
  end
end
