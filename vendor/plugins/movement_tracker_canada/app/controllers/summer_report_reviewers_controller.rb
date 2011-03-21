class SummerReportReviewersController < ApplicationController
  unloadable


  
  def index

    @reviewable_reports = @me.summer_report_reviewers.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end


  def edit
    @review = SummerReportReviewer.find(params[:id])
    @report = @review.summer_report
    @person = @review.summer_report.person
    @year = Year.current
    
    respond_to do |format|
      format.js
    end
  end


  def update
    @review = SummerReportReviewer.find(params[:summer_report_reviewer][:id])
    @review.reviewed = true

    if @review.update_attributes(params[:summer_report_reviewer])
      if @review.approved
        flash[:notice] = "#{@review.summer_report.person.full_name}'s summer schedule is now approved!"
      else
        flash[:notice] = "#{@review.summer_report.person.full_name}'s summer schedule was disapproved."
      end
    end

    respond_to do |format|
      format.html { redirect_to(:action => "index") }
    end
  end

end
