class GroupsController < ApplicationController
  def index
    respond_to do |format|
      format.html do
        layout = is_ministry_leader ? 'manage' : 'application'
        render :layout => layout
      end
      format.js
    end
  end

  def show
    @ministry = @group.ministry
    respond_to do |format|
      format.html 
      format.js
    end
  end

  def new
    respond_to do |format|
      format.html { render :layout => false }
      format.js
    end
  end

  def create
    @group.ministry = @ministry # Add bible study to current ministry
    respond_to do |format|
      if @group.save
        flash[:notice] = @group.class.to_s.titleize + ' was successfully created.'
        format.html { redirect_to groups_url }
        format.js   { index }
        format.xml  { head :created, :location => groups_url(@group) }
      else
        format.html { render :action => "new" }
        format.js   { render :action => "new" }
        format.xml  { render :xml => @group.errors.to_xml }
      end
    end
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    respond_to do |format|
      format.js 
    end
  end

  def destroy
    @group.destroy 
    flash[:notice] = @group.class.to_s.titleize + ' was successfully DELETED.'
    respond_to do |format|
      format.js   { index }
    end
  end
end