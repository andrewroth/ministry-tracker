class MinistryInvolvementsController < ApplicationController
  def destroy
    if @person.all_ministries.size > 1
      @ministry_involvement = MinistryInvolvement.find(params[:id])
      @ministry_involvement.destroy

      respond_to do |format|
        format.xml  { head :ok }
        format.js
      end
    else
      respond_to do |format|
        format.xml  { head :ok }
        format.js   do 
          render :update do |page|
            page.alert('You must leave at least one ministry.')
            page.hide('spinner')
          end
        end
      end
    end
  end
end