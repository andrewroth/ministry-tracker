# CRUD for ministries
#
# A campus is defined as the official government list of campuses in the country.
# A ministry happens on a campus, or several campuses, or no campus at all.
# So everything is attached to a ministry... (ministry should read “movement”...)
#
# There is a heirachy of ministries, then campuses can be tied to ministries,
# but technically aren't part of the ministry heirachy

class MinistriesController < ApplicationController
  layout 'manage'
  skip_before_filter :authorization_filter, :only => [:edit]
  skip_before_filter :get_ministry, :only => [:edit]
  skip_before_filter :force_required_data, :only => [:edit]

  def index
    setup_ministries
    respond_to do |format|
      format.html # index.rhtml
      format.js   # index.rjs
      format.xml  { render :xml => @ministry_involvements.to_xml }
    end
  end
  
  def list
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
  
  # When a user creates a new ministry, they are assigned the top role within 
  # that ministry
  def create
    # set the parent of the current ministry as the parent
    params[:ministry][:parent_id] = @ministry.id || @root_ministry.id
    @ministry = Ministry.new(params[:ministry])
    respond_to do |format|
      top_role = @root_ministry.ministry_roles.find(:first)
      if @ministry.save
        # add the current user to the new ministry as a 
        @person.ministry_involvements.create(_(:ministry_id, :ministry_involvement) => @ministry.id, _(:ministry_role_id, :ministry_involvement) => top_role.id)
        flash[:notice] = 'Ministry was successfully created.'
        format.html { redirect_to ministries_url }
        format.js   { index }
        format.xml  { head :created, :location => ministry_url(@ministry) }
      else
        format.html { render :action => "new" }
        format.js   { render :action => "new" }
        format.xml  { render :xml => @ministry.errors.to_xml }
      end
    end
  end
  
  def edit
    @ministry = Ministry.find(params[:id])
    if is_admin? || @my.ministry_tree.include?(@ministry)
      session[:ministry_id] = @ministry.id
      # get_ministry_involvement(@ministry)
    end
    respond_to do |wants|
      wants.html { redirect_to :back }
      wants.js do 
        render :update do |page| 
          page.reload
        end
      end
    end
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
  
  # Can't delete top level ministries.
  # 
  # Can't delete ministries with children (the world has enough orphans)
  def destroy
    @old_ministry = Ministry.find(params[:id])
    # We can't allow a user to delete a root level ministry
    flash[:warning] = "You can't delete a top level ministry" if @old_ministry == @old_ministry.root
    
    # We don't want users deleting ministries with children. The world already has enough orphans
    #^^^ Tee hee! 
    flash[:warning] = "You can't delete a ministry that has sub-ministries" unless @old_ministry.children.empty?
    if @old_ministry.deleteable?
      # if the active ministry is the one being deleted, we need a new active ministry
      if session[:ministry_id].to_i == @old_ministry.id
        @ministry = @old_ministry.parent
        session[:ministry_id] = @ministry.id
      end
      old_mi = MinistryInvolvement.find(:all, :conditions => {:ministry_id => @old_ministry.id})
      flash[:notice] = 'Ministry Involvements destroyed.'
      @old_ministry.destroy
      setup_ministries
      flash[:notice] = 'Ministry was successfully DELETED.'
      respond_to do |format|
        format.js 
      end
    else
      respond_to do |format|
        format.js do
          render(:update) do |page| 
            page.alert(flash[:warning])
            update_flash(page, flash[:warning], 'warning')
          end
        end
      end
    end
  end

  def switch_list
    #person_ministries = @person.ministry_involvements.collect(&:ministry_id)
    #allowed_ministries << person_ministries.
    @ministries = [ Ministry.first.to_hash_with_children.to_json ]

    #@ministries = [ Ministry.find(15).to_hash_with_children.to_json, Ministry.find(10).to_hash_with_children.to_json ]
  end

  def switch_apply
    @ministry = Ministry.find params[:id]
    # make sure they have a role on this ministry, otherwise bump them to their default ministry
    if get_my_role(@ministry).nil?
      @ministry = nil
      get_ministry
    end
    session[:ministry_id] = @ministry.id
    session[:ministry_role_id] = nil
  end

  # Question: What exactly does parent_form and set_parent do?
  # Delete candidate A: I think parent_form is depreciated as it is now handled by a drag-drop ajax library
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
