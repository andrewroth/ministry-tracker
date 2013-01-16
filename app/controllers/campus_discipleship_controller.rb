class CampusDiscipleshipController < ApplicationController
  unloadable

  before_filter :set_title

  TEAM_LEADER_ROLE = 'Team Leader'  #1
  MINISTRY_LEADER_ROLE = 'Ministry Leader'  #5

  MENTOR_ID_NONE = nil

  def index
    # used routes file to skip "index" in favour of "show"
  end

  def show
    @disc_tree_roots = get_disc_tree_roots

    respond_to do |format|
      format.html {render :action => 'show'}
    end
  end

  def get_disc_tree_roots

    disc_tree_root_ppl = Person.find(:all,
      :select => "#{Person.__(:person_id)} as person_id, #{Person.__(:person_fname)} as First_Name, #{Person.__(:person_lname)} as Last_Name, mr.position",
      :joins => "LEFT JOIN #{MinistryInvolvement.table_name} mi ON mi.person_id = #{Person.table_name}.person_id and mi.end_date is NULL LEFT JOIN #{MinistryRole.table_name} mr ON mr.id = mi.ministry_role_id",
      :conditions => "((person_mentor_id is NULL and (person_mentees_rgt - person_mentees_lft > 1)) or (mr.name in ('#{TEAM_LEADER_ROLE}','#{MINISTRY_LEADER_ROLE}')) and (person_mentees_rgt - person_mentees_lft > 1)) and mi.ministry_id IN(#{@ministry.id})",
      :order => 'mr.position ASC, First_Name ASC',
      :group => "#{Person.__(:person_id)}")

    # return results
    disc_tree_root_ppl
  end

  # GET /people/remove_mentee
  # Removes a person's mentee via a person_id parameter
  # NOTE: currently _discipleship_tree.html.erb just uses 'remove_mentee' directly (may need to use below for Hudson tests, however)
  def remove_disciple
    if params[:id]
      redirect_to :controller => "people", :action => "remove_mentee", :id => params[:id]
    end
  end

  private

  def set_title
    @site_title = 'Discipleship'
  end

end