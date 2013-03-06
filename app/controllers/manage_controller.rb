# Brings you to main management screen.
# Displays all the options for managing a ministry:
# * group management
# * role management

class ManageController < ApplicationController
  layout 'manage'
  
  def index
    setup_ministries
  end

  def merge
  end

  def autocomplete_merge
    @people = Person.search params[:q], 1, 20
    render :layout => false
  end

  def merge_choose_person
    @person1 = Person.find_by_person_id params[:person1_id]
    @person2 = Person.find_by_person_id params[:person2_id]
  end

  protected

  def setup_test_merge_people
    Person.setup_merge_testers
  end
end
