class MinistryRolesController < ApplicationController
  before_filter :ministry_admin_filter
  before_filter :find_ministry_role, :only => [:edit, :update, :destroy]
  def new
    @ministry_role = MinistryRole.new
  end
  
  def create
    type = params[:ministry_role].delete(:type)
    @ministry_role = type.constantize.new(params[:ministry_role])
    @ministry_role.ministry = get_ministry
    if @ministry_role.save
      render
    else
      render :action => :new
    end
  end
  
  def edit
    respond_to do |wants|
      wants.js
    end
  end
  
  def update
    if @ministry_role.update_attributes(params[:ministry_role])
      render
    else
      render :action => :edit
    end
  end
  
  def destroy
    @ministry_role.destroy if @ministry_role.ministry_involvements.empty?
    render :nothing => true
  end
  
  protected
  def find_ministry_role
    @ministry_role = MinistryRole.find(params[:id])
  end
end