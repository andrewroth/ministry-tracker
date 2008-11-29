class MinistriesController < ApplicationController
  layout 'manage'

  def index
    setup_ministries
    respond_to do |format|
      format.html # index.rhtml
      format.js   # index.rjs
      format.xml  { render :xml => @ministry_involvements.to_xml }
    end
  end
  
  def list
    setup_ministries
    @expand_ministry = Ministry.find(params[:node]) if params[:node]
    @expand_ministry ||= @root_ministry
    # session[:ministry_id] = @expand_ministry.id
    render :layout => false
  end
  
  def new
    @ministry = Ministry.new
    @ministry_involvement = MinistryInvolvement.new
    respond_to do |format|
      format.html { render :layout => false }
      format.js
    end
  end
  
  def create
    # set the parent of the current ministry as the parent
    params[:ministry][:parent_id] = @ministry.id || @root_ministry.id
    @new_ministry = Ministry.new(params[:ministry])

    respond_to do |format|
      if params[:ministry_involvement] && @new_ministry.save
        top_role = @new_ministry.ministry_roles.find(:first, :order => Ministry._(:position))
        # add the current user to the new ministry as a 
        @person.ministry_involvements.create(_(:ministry_id, :ministry_involvement) => @new_ministry.id, _(:ministry_role_id, :ministry_involvement) => top_role.id)
        flash[:notice] = 'Ministry was successfully created.'
        format.html { redirect_to ministries_url }
        format.js   { index }
        format.xml  { head :created, :location => ministry_url(@new_ministry) }
      else
        format.html { render :action => "new" }
        format.js   { render :action => "new" }
        format.xml  { render :xml => @new_ministry.errors.to_xml }
      end
    end
  end
  
  def edit
    @ministry = Ministry.find(params[:id])
    get_ministry_involvement(@ministry)
    session[:ministry_id] = @ministry.id
  end
  
  def update
    @ministry = Ministry.find(params[:id])
    get_ministry_involvement(@ministry)
    @ministry_involvement.update_attributes(params[:ministry_involvement]) if @ministry_involvement
    respond_to do |format|
      if @ministry.update_attributes(params[:ministry])
        setup_ministries
        flash[:notice] = 'Ministry was successfully updated.'
        format.html { redirect_to ministries_url }
        format.js
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.js   { render :action => "edit" }
        format.xml  { render :xml => @ministry.errors.to_xml }
      end
    end
  end
  
  def destroy
    @old_ministry = Ministry.find(params[:id])
    # We can't allow a user to delete a root level ministry
    flash[:warning] = "You can't delete a top level ministry" if @old_ministry == @old_ministry.root
    
    # We don't want users deleting ministries with children. The world already has enough orphans
    flash[:warning] = "You can't delete a ministry that has sub-ministries" unless @old_ministry.children.empty?
    
    if @old_ministry.deleteable?
      # if the active ministry is the one being deleted, we need a new active ministry
      if session[:ministry_id].to_i == @old_ministry.id
        @ministry = @ministry.parent
        session[:ministry_id] = @ministry.id
      end
      @old_ministry.destroy 
      setup_ministries
      flash[:notice] = 'Ministry was successfully DELETED.'
      respond_to do |format|
        format.js 
      end
    else
      respond_to do |format|
        format.js do
          render(:update) {|page| update_flash(page, flash[:warning], 'warning')}
        end
      end
    end
  end
  
  def parent_form
    # switch to the ministry they are setting the parent for
    session[:ministry_id] = params[:id]
    get_ministry
    @ministries = Ministry.find(:all, :conditions => ["#{_(:id, 'ministry')} <> ? AND " + 
                                                      "(#{_(:parent_id,'ministry')} <> ? or #{_(:parent_id,'ministry')} is NULL)",
                                                      @ministry.id, @ministry.id], 
                                      :order => _(:name, 'minitry'))
    render :update do |page|
      page[:title].replace_html(@ministry.name)
      page[:manage].replace_html :partial => 'parent_list'
    end
  end
  
  def set_parent
    @parent = Ministry.find_by_id(params[:parent_id])
    if @parent
      @ministry = Ministry.find_by_id(params[:id]) || @ministry
      # Make sure this won't create a looop
      if @ministry.descendants.include?(@parent)
        msg = 'Making <strong>' + @parent.name + '</strong> the parent ministry of <strong>' + @ministry.name + '</strong> would create a circular relationship.' 
      else
        @parent.children << @ministry
        msg = 'You have successfully made <strong>' + @parent.name + '</strong> the parent ministry of <strong>' + @ministry.name + '</strong>.'
      end
    else
      @ministry.update_attribute(:parent_id, nil)
      msg = 'You have successfully made <strong>' + @ministry.name + '</strong> a top level ministry.'
    end
    setup_ministries
    # TODO: Grant read-only permissions to director(s) of parent ministry
    # TODO: Make staff of current ministry staff of parent ministry as well
    # Make students of this ministry involved in root ministry (unless this is now root).
    # Ministry.connection.update("UPDATE #{CampusInvolvement.table_name} "+
    #                               "SET #{_(:ministry_id, :campus_involvement)} = #{@ministry.root.id} "+
    #                               "WHERE #{_(:ministry_id, :campus_involvement)} = #{@ministry.id}") unless @ministry.root == @ministry
    render :update do |page|
      # page[:manage].replace_html(:partial => 'ministries')
      update_flash(page, msg, 'notice')
    end
  end
end