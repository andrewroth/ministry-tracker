class UserCodesController < ApplicationController
  include SemesterSet
  
  skip_before_filter :login_required, :get_person, :get_ministry, :authorization_filter, :force_required_data, :set_initial_campus, :only => [:show]
  before_filter :set_current_and_next_semester, :only => [:generate, :generate_code_for_involved]

  def show
    lc = LoginCode.find_by_code(params[:code])
    uc = UserCode.find_by_login_code_id(lc.id) if lc
    if uc
      session[:code_valid_for_user_id] = uc.user.id
      session[:code_valid_for_person_id] = uc.user.person.id
      pass_params = uc.pass_hash.merge(:controller => params[:send_to_controller], :action => params[:send_to_action])
      uc.click_count += 1
      uc.save!
      logger.info pass_params.inspect
      redirect_to pass_params
    else
      flash[:notice] = "Sorry, no such code was found."
    end
  end

  def self.clear(session)
    session[:code_valid_for_user_id] = nil
    session[:code_valid_for_person_id] = nil
  end
  
  def generate
  end
  
  def generate_code_for_involved
    people = get_involved_people

    ActiveRecord::Base.connection.execute("LOCK TABLES #{UserCode.table_name} WRITE")
    user_codes = people.collect do |person|
      person.user.find_or_create_user_code
    end
    ActiveRecord::Base.connection.execute("UNLOCK TABLES")
    
    user_codes.sort! { |a,b| a.id <=> b.id }
    
    redirect_to :action => :report_generated_codes, :low_id => user_codes.first.id, :high_id => user_codes.last.id, :code_controller => params[:code][:controller], :code_action => params[:code][:action]
  end
  
  def report_generated_codes
    @code_controller = params[:code_controller]
    @code_action = params[:code_action]
    @base_url = base_url
    @user_codes = UserCode.all(:conditions => ["#{UserCode._(:id)} <= ? and #{UserCode._(:id)} >= ?", params[:high_id].to_i, params[:low_id].to_i])
  end
  
  
  
  private
  
  def get_involved_people
    # here we're getting everyone who is involved in a group this semester OR the previous semester
    members = []
    
    if @current_semester.previous_semester
      groups = @current_semester.groups | @current_semester.previous_semester.groups
      groups.each {|group| members = members | group.members | group.leaders | group.co_leaders}
    end
    
    people_ids = members.collect{|member| member.id}
    
    # make sure there are no duplicate emails
    Person.all(:conditions => ["#{Person._(:id)} in (?)", people_ids],
               :select => "distinct #{Person._(:email)}, 
                          #{Person._(:id)},
                          #{Person._(:first_name)},
                          #{Person._(:last_name)}")
  end
end
