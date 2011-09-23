class EmailsController < ApplicationController
  unloadable
    
  layout :get_layout
  
  # GET /emails
  # GET /emails.xml
  def index
    @emails = Email.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @emails }
    end
  end

  # GET /emails/1
  # GET /emails/1.xml
  def show
    @email = Email.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @email }
    end
  end

  # GET /emails/new
  # GET /emails/new.xml
  def new
    if params[:entire_search].to_i == 1
      @email = @my.emails.new(:search_id => params[:search_id])
      search = @email.search
      ids = ActiveRecord::Base.connection.select_values("SELECT distinct(Person.#{_(:id, :person)}) FROM #{Person.table_name} as Person #{search.table_clause} WHERE #{search.query}")
      @people = Person.find(ids)
    else
      @email = @my.emails.new(:people_ids => params[:person].to_json)
      @people = Person.find(:all, :conditions => { Person._(:id) => params[:person] })
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @email }
    end
  end

  # POST /emails
  # POST /emails.xml
  def create
    @email = @my.emails.new(params[:email])

    respond_to do |format|
      if @email.save
        flash[:notice] = "Your email has been created and queued up for delivery. You will receive a notification to <strong>#{@my.primary_email}</strong> 
                          when the email has finished sending."
        format.html { redirect_to(directory_people_path(:format => :html, :search_id => @my.searches.first)) }
        format.xml  { render :xml => @email, :status => :created, :location => @email }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @email.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def bounces
    bouncely = Rbouncely::Bouncely.new(Rbouncely::CONFIG)
    
    if params[:get_bounces] && params[:get_bounces][:date]
      @date = Date.parse(params[:get_bounces][:date])
      @bounces = bouncely.get_bounces(@date)
    else
      @todays_bounces = bouncely.get_bounces("today")
      @yesterdays_bounces = bouncely.get_bounces("yesterday")
    end
  end
  
  
  private
  
  def get_layout
    params[:action] == "bounces" ? "manage" : "application"
  end
end
