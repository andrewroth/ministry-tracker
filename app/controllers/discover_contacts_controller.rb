class DiscoverContactsController < ApplicationController
  before_filter :require_permission, :only => [:show, :edit, :update]
  before_filter :get_my_campuses, :get_current_campus, :set_title

  def index
    @discover_contacts = get_person.discover_contacts.active.with_campus_id(@campus.id)
    @discover_contacts.sort! { |a,b| a.full_name <=> b.full_name }
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
    @discover_contact = DiscoverContact.new(params[:discover_contact])

    if @discover_contact.save
      respond_to do |format|
        ContactsPerson.create(:person_id => get_person.id, :contact_id => @discover_contact.id)
        flash[:notice] = 'Contact added!'
        format.html { redirect_to :action => :index }
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
        format.html { render :action => 'edit' }
      end
    end
  end

  def import_csv
    require 'faster_csv'

    count = 0

    FasterCSV.foreach(params[:file].path, :headers => true) do |row|
      row = row.to_hash.with_indifferent_access


      if row[:next_step_id].blank? && row[:next_step].present?
        row[:next_step_id] = Contact::NEXT_STEP_OPTIONS.select { |ns| row[:next_step].downcase == ns[0].downcase }.try(:first).try(:at, 1)
      end
      row.delete(:next_step)


      if row[:gender_id].blank? && (row[:gender].present? || row[:sex].present?)
        gender = row[:sex] || row[:gender]

        row[:gender_id] = case gender.downcase
        when 'male'
          1
        when 'female'
          2
        else
          0
        end
      end
      row.delete(:sex)
      row.delete(:gender)

      person_id = row.delete(:person_id)

      if contact = DiscoverContact.create!(row)
        count += 1
        ContactsPerson.create(:person_id => person_id, :contact_id => contact.id) if person_id.present?
      end
    end


    flash[:notice] = "Imported #{count} Discover Contacts"
    redirect_to :action => 'upload_csv'
  end


  private

  def require_permission
    redirect_to '/' unless is_admin? || @my.discover_contacts.collect(&:id).include?(params[:id].to_i)
  end

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
    if @me.is_staff_somewhere?
      @my_campuses ||= @me.campuses_under_my_ministries_with_children(::MinistryRole::ministry_roles_that_grant_access("discover_contacts", "index"))
    else
      @my_campuses ||= @me.campuses
    end

    redirect_to '/' unless @my_campuses.present?
  end

  def set_title
    @site_title = 'Discover'
  end
end
