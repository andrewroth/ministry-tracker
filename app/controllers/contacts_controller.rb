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
    @people_available_for_search.each do |e|
      data = {
        :id => e[1],
        :name => e[0],
        :selected => (session[:search_contact_params] && session[:search_contact_params][:assigned_to].present? && session[:search_contact_params][:assigned_to].include?(e[1].to_s)) ? true : false
      }
      assignees.push(data)
    end

    render :json => assignees
  end

  def show
    redirect_to :action => 'edit'
  end
  
  def edit
    @contact = Contact.find(params[:id])
    initialize_globals
  end
  
  def update
    @contact = Contact.find(params[:contact_id])
    [[:assign, :person_id], [:status, :status], [:result, :result]].each do |data|
      @contact[data[1]] = params[data[0]] if params[data[0]].present?
    end

    respond_to do |format|
      if @contact.save
        flash[:notice] = 'Contact was successfully updated.'
        format.html { redirect_to :action => 'search' }
      else
        flash[:notice] = 'Sorry, there was a problem updating the contact!'
        initialize_globals
        format.html { render :action => 'edit' }
      end
    end
  end
  
  def multiple_update
    case params[:multiple_update_action]
    when 'multiple_assign_to'
      assignee = params[:multiple_assign_to]
      if assignee.to_i <= 0
        assignee_person_name = "Unassigned"
      else
        assignee_person = Person.find(assignee)
        assignee_person_name = "#{assignee_person.person_fname} #{assignee_person.person_lname}" if assignee_person
      end

      if assignee_person_name && params[:contacts_to_update].present?
        contact_ids = params[:contacts_to_update].split(',').select { |id| id.to_i > 0 }
        contacts = Contact.find(:all, :conditions => { :id => contact_ids })
        
        contacts.each do |contact|
          contact[:person_id] = assignee
          contact.save!
        end
        
        flash[:notice] = "Assigned selected contacts to #{assignee_person_name}"
      end
      
    when 'multiple_status'
      status = params[:multiple_status].to_i
      status_option = contact_options_lists[:status].select { |s| s[1] == status }.flatten

      if status_option && params[:contacts_to_update].present?
        contact_ids = params[:contacts_to_update].split(',').select { |id| id.to_i > 0 }
        contacts = Contact.find(:all, :conditions => { :id => contact_ids })
        
        contacts.each do |contact|
          contact[:status] = status
          contact.save!
        end
        
        flash[:notice] = "Updated selected contact's status to #{status_option[0]}"
      end

    when 'multiple_result'
      result = params[:multiple_result].to_i
      result_option = contact_options_lists[:result].select { |r| r[1] == result }.flatten

      if result_option && params[:contacts_to_update].present?
        contact_ids = params[:contacts_to_update].split(',').select { |id| id.to_i > 0 }
        contacts = Contact.find(:all, :conditions => { :id => contact_ids })
        
        contacts.each do |contact|
          contact[:result] = result
          contact.save!
        end
        
        flash[:notice] = "Updated selected contact's result to #{result_option[0]}"
      end

    end
  end
  
  def search
    #save all the parameters from the search
    session[:search_contact_params] ||= {}
    search_fields.each do |f|
      session[:search_contact_params][f] = params[f] if params.has_key?(f)
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
      next if value.blank? || value == 'All' || value.to_s == '-1' || value.include?('All') || value.include?('-1')
      case param
      when :campus_id
        desc << "at campus <strong>#{Campus.find(value).name}</strong>" if Campus.exists?(value)

      when :gender_id
        genders = contact_options_lists[:gender_id].select{ |g| value.include?(g[1].to_s) }.collect{ |g| g[0] }
        desc << "with gender <strong>#{to_or_sentence(genders)}</strong>" if genders.present?

      when :priority
        desc << "with priority <strong>#{to_or_sentence(value)}</strong>" if value.present?

      when :status
        statuses = contact_options_lists[:status].select{ |s| value.include?(s[1].to_s) }.collect{ |s| s[0] }
        desc << "with status <strong>#{to_or_sentence(statuses)}</strong>" if statuses.present?

      when :result
        results = contact_options_lists[:result].select{ |r| value.include?(r[1].to_s) }.collect{ |r| r[0] }
        desc << "with result <strong>#{to_or_sentence(results)}</strong>" if results.present?

      when :assigned_to
        list = []
        list << 'Unassigned' if value.include?('0')
        list << 'Assigned' if value.include?('-2')
        values_to_find = value.select{|v| v.to_i > 0 }
        people = Person.find(values_to_find) if Person.exists?(values_to_find)
        list << people.collect{|p| "#{p.person_fname} #{p.person_lname}" } if people.present?
        desc << "assigned to <strong>#{list.join(', ')}</strong>"

      when :international
        country = contact_options_lists[:international].select{ |i| value.include?(i[1].to_s) }.collect{ |i| i[0] }
        desc << "with country <strong>#{to_or_sentence(country)}</strong>" if country.present?

      when :degree
        desc << %(with degree/faculty contains <strong>"#{value}"</strong>)

      end
    end

    "<strong>#{num_results}</strong> search results for contacts #{desc.to_sentence}."
  end

  def do_the_search
    initialize_globals
    @options = []
    @options.push("campus_id = #{@campus_id}") unless @campus_id.nil?
    
    
    [:gender_id, :priority, :status, :result].each do |option|
        @options.push("#{Contact.__(fields_info[option][:field])} IN ('#{@search_options[option].join("','")}')") unless @search_options[option].include?(fields_info[option][:all_value]) if @search_options[option].present?
    end

    if @search_options[:degree] && @search_options[:degree].gsub(/\s/, '').present?
      @options.push("#{Contact.__(fields_info[:degree][:field])} LIKE '%#{@search_options[:degree]}%'")
    end    

    if @search_options[:international].present? && !@search_options[:international].include?(fields_info[:international][:all_value])
      if @search_options[:international] == ["1"]
        @options.push("#{Contact.__(fields_info[:international][:field])} IN ('1')") 
      elsif @search_options[:international] == ["0"]
        @options.push("#{Contact.__(fields_info[:international][:field])} NOT IN ('1')") 
      else
        @search_options[:international] = [fields_info[:international][:all_value]]
      end
    end

    if @search_options[:assign].present?
      unless @search_options[:assign].include?("All") || (@search_options[:assign].include?("Assigned") && @search_options[:assign].include?("Unassigned"))
        if @search_options[:assign].include?("Unassigned")
          @options.push("#{Contact.__(:person_id)} IS NULL")
        else
          @options.push("#{Contact.__(:person_id)} IS NOT NULL")
        end
      end
    end

    if @search_options[:assigned_to].present?
      assignees = []
      @search_options[:assigned_to].each do |p|
        assignees.push(p)
      end
      assigned_to_cond = ""
      unless assignees.include?("-1") # all
        if assignees.include?("0") # unassigned
          assigned_to_cond = "(#{Contact.__(:person_id)} IS NULL OR #{Contact.__(:person_id)} IN (0))"
          assignees.delete("0")
        end
        if assignees.include?("-2") # assigned
          assigned_to_cond = "#{assigned_to_cond} OR " unless assigned_to_cond.blank?
          assigned_to_cond = "#{assigned_to_cond} (#{Contact.__(:person_id)} IS NOT NULL AND #{Contact.__(:person_id)} NOT IN (0))"
          assignees.delete("-2")
        end
        unless assignees.count == 0
          assigned_to_cond = "#{assigned_to_cond} OR " unless assigned_to_cond.blank?
          assigned_to_cond = "#{assigned_to_cond}#{Contact.__(fields_info[:assigned_to][:field])} IN ('#{assignees.join("','")}')"
        end
      end
      @options.push("(#{assigned_to_cond})") unless assigned_to_cond.blank?
    end

    @contacts = Contact.find(:all,
                             :select => "#{Contact.table_name}.*, #{Person.__(:first_name)}, #{Person.__(:last_name)}",
                             :conditions => @options.join(" AND "), :joins => "LEFT JOIN #{Person.table_name} ON #{Person.__(:id)} = #{Contact.table_name}.person_id",
                             :order => contact_order_by).paginate(:page => params[:page])
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
        @search_options[f] = session[:search_contact_params][f] if session[:search_contact_params][f].present?
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
      @people_available.insert(0, ["Assigned", -2])
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
    [:campus_id, :gender_id, :priority, :status, :result, :assigned_to, :sort_col, :sort_dir, :international, :degree]
  end
  
  def fields_info
    {
      :campus_id => { :field => :campus_id, :all_value => nil },
      :gender_id => { :field => :gender_id, :all_value => "9" },
      :priority => { :field => :priority, :all_value => "All" },
      :status => { :field => :status, :all_value => "9" },
      :result => { :field => :result, :all_value => "9" },
      :assigned_to => { :field => :person_id, :all_value => "-1" },
      :international => { :field => :international, :all_value => "9" },
      :degree => { :field => :degree, :all_value => "" }
    }
  end

  def contact_order_by
    order_col = @search_options[:sort_col].present? ? @search_options[:sort_col] : Contact::DEFAULT_SORT_COLUMN
    order_dir = @search_options[:sort_dir].present? ? @search_options[:sort_dir] : Contact::DEFAULT_SORT_DIRECTION

    # sanitize
    order_dir = ['ASC', 'DESC'].include?(order_dir) ? order_dir : Contact::DEFAULT_SORT_DIRECTION
    order_col = contact_search_results_columns.collect { |col| col[:fields].join(',') }.include?(order_col) ? order_col : Contact::DEFAULT_SORT_COLUMN
    params.merge!(:sort_dir => order_dir, :sort_col => order_col)
    @search_options[:sort_col] = order_col
    @search_options[:sort_dir] = order_dir
    session[:search_contact_params][:sort_col] = order_col
    session[:search_contact_params][:sort_dir] = order_dir

    "#{order_col.gsub(',', " #{order_dir},")} #{order_dir}"
  end
  
end
