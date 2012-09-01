class ContactsController < ApplicationController
  include ContactsHelper

  skip_before_filter :authorization_filter, :only => [:assignees_for_campus]


  def index
    initialize_globals
  end
  
  def new
    
  end
  
  def assignees_for_campus
    initialize_people_available_for_search
    assignees = []
    @people_available_for_search.each { |e| assignees.push({ :id => e[1], :name => e[0]})}
    render :json => assignees
  end
  
  def edit
    @contact = Contact.find(params[:id])
    initialize_globals
  end
  
  def save
    contact = Contact.find(params[:contact_id])
    [[:assign, :person_id], [:status, :status], [:result, :result]].each do |data|
      contact[data[1]] = params[data[0]] if params[data[0]].present?
    end
    contact.save!

    render 'index'
  end
  
  def multiple_assign
    assignee = params[:multiple_assign_to]
    if assignee.to_i <= 0
      assignee_person_name = "Unassigned"
    else
      assignee_person = Person.find(assignee)
      assignee_person_name = "#{assignee_person.person_fname} #{assignee_person.person_lname}" if assignee_person
    end

    if assignee_person_name && params[:contacts_to_assign]
      contact_ids = params[:contacts_to_assign].split(',')
      contact_ids.delete("0")
      contacts = Contact.find(:all, :conditions => { :id => contact_ids })
      
      contacts.each do |contact|
        contact[:person_id] = assignee
        contact.save!
      end
      
      flash[:notice] = "Assigned contacts to #{assignee_person_name}"
    end
  end
  
  def search
    #save all the parameters from the search
    session[:search_contact_params] ||= {}
    search_fields.each do |f|
      session[:search_contact_params][f] = params[f]
    end

    @campus_id = session[:search_contact_params][:campus_id] if session[:search_contact_params][:campus_id].present?

    do_the_search

    @search_description = search_description(session[:search_contact_params], @contacts.total_entries)

    render 'index'
  end

  def impact_report
    @campuses = campuses(::MinistryRole::ministry_roles_that_grant_access("contacts", "index"))
    @campus = Campus.find(params[:campus_id]) if params[:campus_id]
    @campus = @campuses.first if @campus.blank? || !@campuses.include?(@campus)
  end
  
  
private

  def search_description(params, num_results)
    desc = []

    params.each do |param, value|
      next if value.blank? || value == 'All' || value.to_s == '-1' || value.include?('All')
      case param
      when :campus_id
        desc << "at campus <strong>#{Campus.find(value).name}</strong>" if Campus.exists?(value)

      when :gender_id
        genders = contact_options_lists[:gender_id].select{ |g| value.include?(g[1].to_s) }.collect{ |g| g[0] }
        desc << "with gender <strong>#{to_or_sentence(genders)}</strong>" if genders.present?

      when :priority
        desc << "with priority <strong>#{to_or_sentence(value)}</strong>" if value.present?

      when :assign
        desc << "with assign <strong>#{value.join(', ')}</strong>" if value.present?

      when :status
        statuses = contact_options_lists[:status].select{ |s| value.include?(s[1].to_s) }.collect{ |s| s[0] }
        desc << "with status <strong>#{to_or_sentence(statuses)}</strong>" if statuses.present?

      when :result
        results = contact_options_lists[:result].select{ |r| value.include?(r[1].to_s) }.collect{ |r| r[0] }
        desc << "with result <strong>#{to_or_sentence(results)}</strong>" if results.present?

      when :assigned_to
        list = []
        list << 'Unassigned' if value.delete('0')
        people = Person.find(value) if Person.exists?(value)
        list << people.collect{|p| "#{p.person_fname} #{p.person_lname}" } if people.present?
        desc << "assigned to <strong>#{list.join(', ')}</strong>"
      end
    end

    "<strong>#{num_results}</strong> search results for contacts #{desc.to_sentence}."
  end

  def do_the_search
    initialize_globals
    @options = []
    @options.push("campus_id = #{@campus_id}") unless @campus_id.nil?
    
    
    [:gender_id, :priority, :status, :result].each do |option|
        @options.push("#{fields_info[option][:field]} IN ('#{@search_options[option].join("','")}')") unless @search_options[option].include?(fields_info[option][:all_value]) if @search_options[option].present?
    end

    if @search_options[:assign].present?
      unless @search_options[:assign].include?("All") || (@search_options[:assign].include?("Assigned") && @search_options[:assign].include?("Unassigned"))
        if @search_options[:assign].include?("Unassigned")
          @options.push("person_id IS NULL")
        else
          @options.push("person_id IS NOT NULL")
        end
      end
    end

    if @search_options[:assigned_to].present?
      assignees = []
      @search_options[:assigned_to].each do |p|
        assignees.push(p)
      end
      assigned_to_cond = ""
      unless assignees.include?("-1")
        if assignees.include?("0")
          assigned_to_cond = "person_id IS NULL"
        end
        assignees.delete("0")
        unless assignees.count == 0
         assigned_to_cond = "#{assigned_to_cond} OR " unless assigned_to_cond == ""
         assigned_to_cond = "#{assigned_to_cond}#{fields_info[:assigned_to][:field]} IN ('#{assignees.join("','")}')"
        end
      end
      @options.push("(#{assigned_to_cond})") unless assigned_to_cond == ""
    end

    @contacts = Contact.find(:all, :conditions => @options.join(" AND ")).paginate(:page => params[:page])
  end

  def initialize_globals
    initialize_search_options
    initialize_campus_id
    initialize_people_available
    initialize_people_available_for_search
  end
  
  def initialize_search_options
    @search_options ||= {}
    if session[:search_contact_params].present?
      search_fields.each do |f|
        @search_options[f] = session[:search_contact_params][f]
      end
    end
  end
  
  def initialize_campus_id
    @campus_id ||= params[:campus_id] if params[:campus_id].present?
    @campus_id ||= @contact[:campus_id] unless @contact.nil?
    @campus_id ||= @search_options[:campus_id] unless @search_options.nil?
    @campus_id
  end
  
  def ministry_leaf_and_over(campus_id)
    ans = []
    Campus.find(campus_id).ministries.each do |m|
      if m[:ministries_count] == 0
        ans.push(m[:id])
        ans.push(m.parent[:id])
      end
    end
    ans
  end
  
  def initialize_people_available
    @people_available ||= []
    unless @people_available.count > 0 || initialize_campus_id.nil?
      MinistryInvolvement.find(:all, :conditions => {:ministry_role_id => [1, 5, 6, 13], :ministry_id => ministry_leaf_and_over(@campus_id)}).collect{|mi| mi[:person_id]}.each do |pid|
        if Person.exists?(pid)
          p = Person.find(pid)
          @people_available.push(["#{p[:person_fname].capitalize} #{p[:person_lname].capitalize}", pid])
        end
      end
      @people_available = @people_available.uniq if @people_available.count > 0
      @people_available.sort!{|x,y| x[0] <=> y [0]} if @people_available.count > 0
      @people_available.insert(0, ["Unassigned", 0])
    end
    @people_available
  end
  
  def initialize_people_available_for_search
    unless @people_available_for_search
      @people_available_for_search = [["All", -1]]
      initialize_people_available.each do |p|
        @people_available_for_search.push(p)
      end
    end
    @people_available_for_search
  end


  def search_fields
    [:campus_id, :gender_id, :priority, :assign, :status, :result, :assigned_to]
  end
  
  def fields_info
    {
      :campus_id => { :field => :campus_id, :all_value => nil },
      :gender_id => { :field => :gender_id, :all_value => "9" },
      :priority => { :field => :priority, :all_value => "All" },
      :assign => { :field => :assign, :all_value => "All" },
      :status => { :field => :status, :all_value => "9" },
      :result => { :field => :result, :all_value => "9" },
      :assigned_to => { :field => :person_id, :all_value => "-1" }
    }
  end
  
end
