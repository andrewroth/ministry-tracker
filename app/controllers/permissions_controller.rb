# CRUD for permissions
class PermissionsController < ApplicationController
  layout 'manage'
  before_filter :developer_filter
  before_filter :find_permission, :only => [:edit, :update, :destroy]
  def index
    @permissions = Permission.find(:all)
    respond_to do |format|
      format.html
    end
  end
  
  def new
    @permission = Permission.new
  end
  
  def edit
    
  end
  
  def update
    unless @permission.update_attributes(params[:permission])
      render :action => :edit
    end
  end
  
  def create
    @permission = Permission.new(params[:permission])
    unless @permission.save
      render :action => :new
    end
  end
  
  def destroy
    @permission.destroy
  end
  
  protected
  def find_permission
    @permission = Permission.find(params[:id])
  end
end