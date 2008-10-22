class CampusInvolvementsController < ApplicationController
  def destroy
    # if @person.campus_involvements.count > 1
      @campus_involvement = CampusInvolvement.find(params[:id])
      @campus_involvement.destroy

      respond_to do |format|
        format.xml  { head :ok }
        format.js
      end
    # else
    #      respond_to do |format|
    #        format.xml  { head :ok }
    #        format.js   do 
    #          render :update do |page|
    #            page.alert('You must leave at least one campus.')
    #            page.hide('spinner')
    #          end
    #        end
         # end
    # end
  end
end