# 
#  group_type_controller.rb
#  movement_tracker
#  
#  Created by Daniel Harsojo on 2009-01-26.
#  Copyright 2009 Daniel Harsojo. All rights reserved.
# 

class GroupTypesController < ApplicationController
    layout 'manage'
    before_filter :find_group_type, :only => [:edit, :update, :destroy, :permissions]
    
  # GET /group_types
  # GET /group_types.xml
  def index
    # find all group types belonging to your ministry
    ministry_id = @ministry ? @ministry.id : 0
    @group_types = GroupType.find(:all, :conditions => "ministry_id = #{ministry_id}")
    pageTitle = "Group Type Editor"
    respond_to do |format|
      layout = 'manage'
      format.html { render :layout => layout } # index.html.erb
      format.xml  { render :xml => @group_types }
    end
  end


  # GET /group_types/new
  # GET /group_types/new.xml
  def new
    @group_type = GroupType.new
    #@group_type.ministry_id = @ministry ? @ministry.id : 0
    #respond_to do |format|
    #  layout = 'manage'
    #  format.html { render :layout => layout } # new.html.erb
    #  format.xml  { render :xml => @group_type }
    #end
  end

  # GET /group_types/1/edit
  def edit
  end


  # POST /group_types
  # POST /group_types.xml
  def create
    @group_type = GroupType.new(params[:group_type])
    @group_type.ministry = get_ministry.root
    
    if @group_type.save
      render
    else
      render :action => :new
    end
  end
  
  

  # PUT /group_types/1
  # PUT /group_types/1.xml
  def update
    @group_type = GroupType.find(params[:id])

    respond_to do |format|
      if @group_type.update_attributes(params[:group_type])
        flash[:notice] = 'GroupType was successfully updated.'
        format.html { redirect_to(group_types_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /group_types/1
  # DELETE /group_types/1.xml
  def destroy
    @group_type = GroupType.find(params[:id])
    @group_type.destroy

    respond_to do |format|
      format.html { redirect_to(group_types_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
  def find_group_type
    @group_type = GroupType.find(params[:id])
  end
end
