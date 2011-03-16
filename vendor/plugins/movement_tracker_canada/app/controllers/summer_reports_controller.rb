class SummerReportsController < ApplicationController
  # GET /summer_reports
  # GET /summer_reports.xml
  def index
    @summer_reports = SummerReport.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @summer_reports }
    end
  end

  # GET /summer_reports/1
  # GET /summer_reports/1.xml
  def show
    @summer_report = SummerReport.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @summer_report }
    end
  end

  # GET /summer_reports/new
  # GET /summer_reports/new.xml
  def new
    @summer_report = SummerReport.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @summer_report }
    end
  end

  # GET /summer_reports/1/edit
  def edit
    @summer_report = SummerReport.find(params[:id])
  end

  # POST /summer_reports
  # POST /summer_reports.xml
  def create
    @summer_report = SummerReport.new(params[:summer_report])

    respond_to do |format|
      if @summer_report.save
        format.html { redirect_to(@summer_report, :notice => 'SummerReport was successfully created.') }
        format.xml  { render :xml => @summer_report, :status => :created, :location => @summer_report }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @summer_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /summer_reports/1
  # PUT /summer_reports/1.xml
  def update
    @summer_report = SummerReport.find(params[:id])

    respond_to do |format|
      if @summer_report.update_attributes(params[:summer_report])
        format.html { redirect_to(@summer_report, :notice => 'SummerReport was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @summer_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /summer_reports/1
  # DELETE /summer_reports/1.xml
  def destroy
    @summer_report = SummerReport.find(params[:id])
    @summer_report.destroy

    respond_to do |format|
      format.html { redirect_to(summer_reports_url) }
      format.xml  { head :ok }
    end
  end
end
