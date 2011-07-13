class LabelPeopleController < ApplicationController
  # GET /label_people
  # GET /label_people.xml
  def index
    @label_people = LabelPerson.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @label_people }
    end
  end

  # GET /label_people/1
  # GET /label_people/1.xml
  def show
    @label_person = LabelPerson.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @label_person }
    end
  end

  # GET /label_people/new
  # GET /label_people/new.xml
  def new
    @label_person = LabelPerson.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @label_person }
    end
  end

  # GET /label_people/1/edit
  def edit
    @label_person = LabelPerson.find(params[:id])
  end

  # POST /label_people
  # POST /label_people.xml
  def create
    @label_person = LabelPerson.new(params[:label_person])

    respond_to do |format|
      if @label_person.save
        format.html { redirect_to(@label_person, :notice => 'LabelPerson was successfully created.') }
        format.xml  { render :xml => @label_person, :status => :created, :location => @label_person }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @label_person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /label_people/1
  # PUT /label_people/1.xml
  def update
    @label_person = LabelPerson.find(params[:id])

    respond_to do |format|
      if @label_person.update_attributes(params[:label_person])
        format.html { redirect_to(@label_person, :notice => 'LabelPerson was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @label_person.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /label_people/1
  # DELETE /label_people/1.xml
  def destroy
    @label_person = LabelPerson.find(params[:id])
    @label_person.destroy

    respond_to do |format|
      format.html { redirect_to(label_people_url) }
      format.xml  { head :ok }
    end
  end
end
