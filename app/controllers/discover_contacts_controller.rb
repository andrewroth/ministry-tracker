class DiscoverContactsController < ApplicationController
  before_filter :get_my_campuses, :get_current_campus, :set_title

  def index
    @discover_contacts = get_person.discover_contacts.active.with_campus_id(@campus.id)
  end
  
  def new
    @discover_contact = DiscoverContact.new
  end
  
  def show
    redirect_to :action => 'edit'
  end
  
  def edit
    @discover_contact = DiscoverContact.find(params[:id], :include => {:notes => :person})
  end

  def create
    @discover_contact = DiscoverContact.new(params[:discover_contact].merge({:active => true}))

    if @discover_contact.save
      respond_to do |format|
        ContactsPerson.create(:person_id => get_person.id, :contact_id => @discover_contact.id)
        format.html { redirect_to :action => :index, :notice => 'Contact added!' }
      end
    else
      render :new
    end
  end
  
  def update
    @discover_contact = DiscoverContact.find(params[:id])
    @discover_contact.update_attributes(params[:discover_contact])

    respond_to do |format|
      if @discover_contact.save        
        flash[:notice] = 'Contact updated!'
        format.html { redirect_to :action => 'index' }
        
      else
        flash[:notice] = 'Sorry, there was a problem updating the contact!'
        format.html { render :action => 'edit' }
      end
    end
  end
    

  private

  def get_current_campus
    if params[:campus_id].present?
      @campus = Campus.find(params[:campus_id])
    elsif session[:contact_campus_id].present?
      @campus = Campus.find(session[:contact_campus_id])
    else
      @campus = @my_campuses.first
    end

    @campus = @my_campuses.include?(@campus) ? @campus : @my_campuses.first

    session[:contact_campus_id] = @campus.id
  end

  def get_my_campuses
    @my_campuses = get_person_current_campuses
    redirect_to :controller => :dashboard, :action => :index unless @my_campuses.present?
  end

  def set_title
    @site_title = 'Discover'
  end
end
