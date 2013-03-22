# Brings you to main management screen.
# Displays all the options for managing a ministry:
# * group management
# * role management

class ManageController < ApplicationController
  layout 'manage'
  
  UNCOPYABLE = {
    Person => %w(person_id person_mentees_lft person_mentees_rgt),
    User => %w(viewer_id),
    Emerg => %w(emerg_id)
  }

  def create_testers
    p1, p2 = Person.setup_merge_testers
    flash[:notice] = "Created tester #{p1.full_name} and #{p2.full_name}"
    redirect_to :action => :merge
  end

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
    keep = Person.find params[:keep_id]
    other = Person.find params[:other_id]
    other_name = other.full_name
    other_id = other.id
    keep.merge(other)
    flash[:notice] = "Merged #{other_name} (person id #{other_id}) into #{keep.full_name} (person id #{keep.id})."
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
