# Brings you to main management screen.
# Displays all the options for managing a ministry:
# * group management
# * role management

class ManageController < ApplicationController
  layout 'manage'
  
  UNCOPYABLE = {
    Person => %w(person_id person_mentees_lft person_mentees_rgt),
    User => %w(viewer_id),
    Emerg => %w(emerg_id),
    GroupInvolvement => :all,
    Group => :all
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
    @people.sort!{ |p1, p2| p1.last_name == p2.last_name ? p1.first_name <=> p2.first_name : p1.last_name <=> p2.last_name }
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
    merge_log = get_person.merges.create :keep_person_id => keep.id, :keep_viewer_id => keep.try(:user).try(:id), :other_person_id => other.id, :other_viewer_id => other.try(:user).try(:id)
    begin
      errors = keep.merge(other)
      merge_log.success = true
      merge_log.sql_error = errors.present?
      merge_log.error_message = errors.join("\n")
      merge_log.save!
      message = "Merged #{other_name} (person id #{other_id}) into #{keep.full_name} (person id #{keep.id})."
      message += "  However, there were errors encountered during the merge.  SQL statements that caused an error were skipped, and the rest of the merge was performed successfully.<br/><br/>#{errors.join("<br/>")}<br/><br/>Merge log id #{merge_log.id}" if errors.present?
      flash[:notice] = message
    rescue => e
      flash[:warning] = "There was an error merging: '#{e.message}'  See the merge log id #{merge_log.id} for the stack trace."
      merge_log.success = false
      merge_log.error_message = e.message + "\n" + e.backtrace.join("\n")
      merge_log.save!
    end
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
