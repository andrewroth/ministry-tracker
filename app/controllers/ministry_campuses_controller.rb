class MinistryCampusesController < ApplicationController
  before_filter :get_countries
  skip_before_filter :get_ministry, :only => :index
  layout 'manage'
  
  def index
    @ministry = Ministry.find(session[:ministry_id])
    respond_to do |format|
      format.html
      format.js 
    end
  end
  
  def list
    @ministry = Ministry.find(params[:ministry_id])
    respond_to do |wants|
      wants.js
    end
  end
  
  def new
    get_countries
    @ministry = Ministry.find(params[:ministry_id])
  end
  
  def create
    respond_to do |format|
      begin
        @campus = Campus.find(params[:campus_id])
        # Add campus to ministry
        @ministry = Ministry.find(params[:ministry_id])
        @ministry_campus = MinistryCampus.create(_(:campus_id, 'ministry_campus') => params[:campus_id],
                                              _(:ministry_id, 'ministry_campus') => @ministry.id)
                                              
        @states = State.all()
        @campuses = Campus.find_all_by_country(params[:country_id], :order => 'name') if @states.nil? 
        flash[:notice] = @campus.name + ' was successfully added.'
        format.html { redirect_to address_url(@address) }
        format.js 
        format.xml  { head :created, :location => address_url(@address) }
      rescue ActiveRecord::StatementInvalid
        flash[:warning] = "You can't add the same campus to your ministry twice."
        format.html { render :action => "new" }
        format.js   do 
          render :update do |page|
            update_flash(page)
          end
        end
        format.xml  { render :xml => @address.errors.to_xml }
      end
    end
  end
  
  def update
    if params
      if params[:tree_head_id] && params[:id]
        cur_min_camp = MinistryCampus.find_by_id(params[:id])
        cur_min_camp.tree_head_id = params[:tree_head_id]
        cur_min_camp.save
        flash[:notice] = cur_min_camp.campus.name + "'s tree head was changed."
      end
      respond_to do |format|
        format.js do
          render :update do |page|
            update_flash(page)
          end
        end
      end
    end
  end
  
  def destroy
    @ministry_campus = MinistryCampus.find(params[:id])
    @campus = @ministry_campus.campus
    @ministry_campus.destroy

    respond_to do |format|
      format.js  do
        render :update do |page|
          page.remove dom_id(@ministry_campus)
        end
      end
      format.xml  { head :ok }
    end
  end
  
  protected
end
