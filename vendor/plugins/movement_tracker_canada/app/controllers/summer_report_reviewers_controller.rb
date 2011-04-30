class SummerReportReviewersController < ApplicationController
  unloadable

  before_filter :get_summer_year
  
  def index
    @reviewable_reports = SummerReportReviewer.all(:joins => :summer_report,
      :conditions => ["#{SummerReport.__(:year_id)} = ? and #{SummerReportReviewer.__(:person_id)} = ?", @current_year.id, @my.id])

    respond_to do |format|
      format.html # index.html.erb
    end
  end


  def edit
    @review = SummerReportReviewer.find(params[:id])
    @report = @review.summer_report
    @person = @review.summer_report.person
    
    respond_to do |format|
      format.js
    end
  end


  def update
    @review = SummerReportReviewer.find(params[:summer_report_reviewer][:id])
    @review.reviewed = true

    if @review.update_attributes(params[:summer_report_reviewer])

      @review.summer_report.send_later(:send_reviewed_email, base_url)

      if @review.approved
        flash[:notice] = "#{@review.summer_report.person.full_name}'s summer schedule is now approved and they'll be notified by email!"
      else
        flash[:notice] = "#{@review.summer_report.person.full_name}'s summer schedule was disapproved and they'll be notified by email."
      end
    end

    respond_to do |format|
      format.html { redirect_to(:action => "index") }
    end
  end


  private

  def get_summer_year
    @current_year = Year.current
  end
end
