class RecruitmentsController < ApplicationController

  def show
    @recruitment = Recruitment.find(params[:id])
    redirect_to @recruitment.person
  end

  def update
    @recruitment = Recruitment.find(params[:id])

    unless @recruitment.update_attributes(params[:recruitment])
      flash[:warning] = "Sorry, there was a problem saving recruitment information."
    end
  end

end
