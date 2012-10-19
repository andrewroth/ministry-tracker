class ActivitiesController < ApplicationController

  def create
    @reportable = find_reportable
    @activity = @reportable.activities.build(params[:activity])
    @activity.reporter_id = get_person.try(:id)

    respond_to do |format|
      if @activity.save
        format.html { redirect_to @reportable, :notice => 'Rejoiceable added!' }
      else
        redirect_to :back
      end
    end
  end

  private

  def find_reportable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end

end
