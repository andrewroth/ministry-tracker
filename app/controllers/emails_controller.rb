class EmailsController < ApplicationController
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
    else
      @email = @my.emails.new(:people_ids => params[:person].to_json)
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

  # DELETE /emails/1
  # DELETE /emails/1.xml
  def destroy
    @email = Email.find(params[:id])
    @email.destroy

    respond_to do |format|
      format.html { redirect_to(emails_url) }
      format.xml  { head :ok }
    end
  end
end
