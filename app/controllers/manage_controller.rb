# Brings you to main management screen.
# Displays all the options for managing a ministry:
# * group management
# * role management

class ManageController < ApplicationController
  layout 'manage'
  
  UNCOPYABLE = {
    Person => %w(person_id),
    User => %w(viewer_id),
    Emerg => %w(emerg_id)
  }

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

  def perform_merge
  end

  def copy_value_over
    klass = params[:model].constantize
    source = klass.find(params[:source_id])
    dest = klass.find(params[:dest_id])
    column = params[:column]
    @value = source.send(column)
    dest.send("#{column}=", @value)
    dest.save(false)
  end

  protected

  def setup_test_merge_people
    Person.setup_merge_testers
  end
end
