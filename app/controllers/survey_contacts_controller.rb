require 'csv'

class SurveyContactsController < ApplicationController
  include SurveyContactsHelper

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
    @contact = SurveyContact.find(params[:id], :include => {:notes => :person})
    initialize_globals
  end
  
  def update
    @contact = SurveyContact.find(params[:contact_id])

    send_assign_notification = (params[:assign].present? && @contact.person_id.to_i != params[:assign].to_i) ? true : false

    [[:assign, :person_id], [:status, :status], [:result, :result], [:nextStep, :nextStep]].each do |data|
      @contact[data[1]] = params[data[0]] if params[data[0]].present?
    end

    respond_to do |format|
      if @contact.save        
        flash[:notice] = 'Contact was successfully updated.'

        if send_assign_notification && @contact.person
          send_assigned_contacts_email([@contact]) 
          flash[:notice] = "#{flash[:notice]} #{@contact.person.first_name} #{@contact.person.last_name} will be notified by email."
        end

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
        contacts = SurveyContact.find(:all, :conditions => { :id => contact_ids })
        
        saved_successfully = []

        contacts.each do |contact|
          contact[:person_id] = assignee
          saved_successfully << contact.save!
        end
        
        unless saved_successfully.include?(false)
          flash[:notice] = "Assigned selected contacts to #{assignee_person_name}, they will be notified by email."
          send_assigned_contacts_email(contacts) if assignee_person
        else
          flash[:notice] = "Sorry, there was a problem assigning the selected contacts!"
        end
      end
      
    when 'multiple_status'
      status = params[:multiple_status].to_i
      status_option = contact_options_lists[:status].select { |s| s[1] == status }.flatten

      if status_option && params[:contacts_to_update].present?
        contact_ids = params[:contacts_to_update].split(',').select { |id| id.to_i > 0 }
        contacts = SurveyContact.find(:all, :conditions => { :id => contact_ids })
        
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
        contacts = SurveyContact.find(:all, :conditions => { :id => contact_ids })
        
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

    respond_to do |format|
      format.html do
        do_the_search
        @search_description = search_description(session[:search_contact_params], @contacts.total_entries)
        render 'index'
      end

      format.csv do
        do_the_search(:paginate => false)

        filepath = "tmp/#{Time.now.to_i}"

        csv_str = FasterCSV.open(filepath, "w") do |csv|
          csv << SurveyContact.columns_hash.collect { |column_name, column_hash| column_name }

          @contacts.each do |contact|
            csv << SurveyContact.columns_hash.collect do |column_name, column_hash|
              contact[column_name]
            end
          end
        end

        user_filename = Campus.find(@campus_id).try(:short_name) ? "#{@contacts.total_entries} contacts at #{Campus.find(@campus_id).short_name}".gsub(/[^0-9A-Za-z ]/, '') : "contacts"
        send_file filepath, :filename => "#{user_filename}.csv", :type => "text/csv"
      end
    end
  end

  def impact_report
    @campuses = campuses(::MinistryRole::ministry_roles_that_grant_access("survey_contacts", "index"))
    @campus = Campus.find(params[:campus_id]) if params[:campus_id]
    @campus = @campuses.first if @campus.blank? || !@campuses.include?(@campus)
  end

  def national_report
    campus_ids = SurveyContact.all(:select => 'DISTINCT campus_id', :conditions => 'campus_id IS NOT NULL AND campus_id > 0').collect(&:campus_id)
    @campuses = Campus.all(:conditions => ["#{Campus._(:id)} IN (?)", campus_ids], :order => "#{Campus._(:desc)} ASC")
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

      when :data_input_notes
        desc << %(with data input notes contains <strong>"#{value}"</strong>)
        
      when :interest
        interests = contact_options_lists[:interest].select{ |i| value.include?(i[1].to_s) }.collect{ |i| i[0] }
        desc << "with interest <strong>#{to_or_sentence(interests)}</strong>" if interests.present?

      when :magazine
        magazines = contact_options_lists[:magazine].select{ |i| value.include?(i[1].to_s) }.collect{ |i| i[0] }
        desc << "with magazine <strong>#{to_or_sentence(magazines)}</strong>" if magazines.present?

      when :journey
        journies = contact_options_lists[:journey].select{ |i| value.include?(i[1].to_s) }.collect{ |i| i[0] }
        desc << "with journey <strong>#{to_or_sentence(journies)}</strong>" if journies.present?

      end
    end

    if @contacts.total_entries > @contacts.size
      description = "Showing <strong>#{@contacts.total_entries > 0 ? 1 + @contacts.offset : 0}-#{@contacts.offset + @contacts.size}</strong> of <strong>#{@contacts.total_entries}</strong>"
    else
      description = "<strong>#{num_results}</strong>"
    end

    "#{description} search results for contacts #{desc.to_sentence}."
  end

  def do_the_search(options = {})
    options[:paginate] = true if options[:paginate].nil?
    per_page = params[:per_page].present? ? params[:per_page] : nil
    per_page = options[:paginate] ? per_page : SurveyContact.all.size

    initialize_globals
    condition = []
    condition_args = []

    unless @campus_id.nil?
      condition << "campus_id = ?" 
      condition_args << @campus_id
    end
    
    [:gender_id, :priority, :status, :result, :interest, :magazine, :journey].each do |option|
      if @search_options[option].present? && !@search_options[option].include?(fields_info[option][:all_value])

        if @search_options[option].include?("") || (fields_info[option].has_key?(:blank_value) && @search_options[option].include?(fields_info[option][:blank_value]))
          condition << "(#{SurveyContact.__(fields_info[option][:field])} IN (?) OR #{SurveyContact.__(fields_info[option][:field])} IS NULL)"
          condition_args << [@search_options[option], fields_info[option][:blank_value]].flatten
          
        else
          condition << "#{SurveyContact.__(fields_info[option][:field])} IN (?)"
          condition_args << @search_options[option]
        end
      end
    end

    if @search_options[:degree] && @search_options[:degree].gsub(/\s/, '').present?
      condition << "#{SurveyContact.__(fields_info[:degree][:field])} LIKE ?"
      condition_args << "%#{@search_options[:degree]}%"
    end

    if @search_options[:data_input_notes] && @search_options[:data_input_notes].gsub(/\s/, '').present?
      condition << "#{SurveyContact.__(fields_info[:data_input_notes][:field])} LIKE ?"
      condition_args << "%#{@search_options[:data_input_notes]}%"
    end

    if @search_options[:international].present? && !@search_options[:international].include?(fields_info[:international][:all_value])
      if @search_options[:international] == ["1"]
        condition << "#{SurveyContact.__(fields_info[:international][:field])} IN ('1')"
      elsif @search_options[:international] == ["0"]
        condition << "#{SurveyContact.__(fields_info[:international][:field])} NOT IN ('1')"
      else
        @search_options[:international] = [fields_info[:international][:all_value]]
      end
    end

    if @search_options[:assign].present?
      unless @search_options[:assign].include?("All") || (@search_options[:assign].include?("Assigned") && @search_options[:assign].include?("Unassigned"))
        if @search_options[:assign].include?("Unassigned")
          condition << "#{SurveyContact.__(:person_id)} IS NULL"
        else
          condition << "#{SurveyContact.__(:person_id)} IS NOT NULL"
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
          assigned_to_cond = "(#{SurveyContact.__(:person_id)} IS NULL OR #{SurveyContact.__(:person_id)} IN (0))"
          assignees.delete("0")
        end

        if assignees.include?("-2") # assigned
          assigned_to_cond = "#{assigned_to_cond} OR " unless assigned_to_cond.blank?
          assigned_to_cond = "#{assigned_to_cond}(#{SurveyContact.__(:person_id)} IS NOT NULL AND #{SurveyContact.__(:person_id)} NOT IN (0))"
          assignees.delete("-2")
        end

        unless assignees.count == 0
          assigned_to_cond = "#{assigned_to_cond} OR " unless assigned_to_cond.blank?
          assigned_to_cond = "#{assigned_to_cond}#{SurveyContact.__(fields_info[:assigned_to][:field])} IN (?)"
          condition_args << assignees
        end
      end

      condition << "(#{assigned_to_cond})" unless assigned_to_cond.blank?
    end

    @contacts = SurveyContact.find(:all,
                             :select => "#{SurveyContact.table_name}.*, #{Person.__(:first_name)}, #{Person.__(:last_name)}",
                             :conditions => [condition.join(" AND ")] + condition_args,
                             :joins => "LEFT JOIN #{Person.table_name} ON #{Person.__(:id)} = #{SurveyContact.table_name}.person_id",
                             :order => contact_order_by).paginate(:page => params[:page], :per_page => per_page)
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
      if m.children.size == 0
        ans.push(m[:id])
        ans.push(m.parent[:id])
      end
    end
    ans
  end
  
  def initialize_people_available
    @people_available ||= []
    unless @people_available.count > 0 || initialize_campus_id.nil?
      person_ids = MinistryInvolvement.find(:all, :conditions => {:ministry_role_id => [1, 5, 6, 13], :ministry_id => ministry_leaf_and_over(@campus_id), :end_date => nil}).collect(&:person_id)

      people = Person.find(:all, :conditions => ["#{Person._(:id)} IN (?)", person_ids]) | Campus.find(@campus_id).leaders_with_contacts

      people.each do |p|
        @people_available.push(["#{p[:person_fname]} #{p[:person_lname]}", p.id])
      end

      @people_available = @people_available.uniq if @people_available.count > 0
      @people_available.sort! { |x,y| x[0].downcase <=> y [0].downcase } if @people_available.count > 0
      
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
    [:campus_id, :gender_id, :priority, :status, :result, :assigned_to, :sort_col, :sort_dir, :international, :degree, :data_input_notes, :interest, :magazine, :journey]
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
      :degree => { :field => :degree, :all_value => "" },
      :data_input_notes => { :field => :data_input_notes, :all_value => "" },
      :interest => { :field => :interest, :all_value => "9", :blank_value => "0" },
      :magazine => { :field => :magazine, :all_value => "9" },
      :journey => { :field => :journey, :all_value => "9" }
    }
  end

  def contact_order_by
    order_col = @search_options[:sort_col].present? ? @search_options[:sort_col] : SurveyContact::DEFAULT_SORT_COLUMN
    order_dir = @search_options[:sort_dir].present? ? @search_options[:sort_dir] : SurveyContact::DEFAULT_SORT_DIRECTION

    # sanitize
    order_dir = ['ASC', 'DESC'].include?(order_dir) ? order_dir : SurveyContact::DEFAULT_SORT_DIRECTION
    order_col = contact_search_results_columns.collect { |col| col[:fields].join(',') }.include?(order_col) ? order_col : SurveyContact::DEFAULT_SORT_COLUMN
    params.merge!(:sort_dir => order_dir, :sort_col => order_col)
    @search_options[:sort_col] = order_col
    @search_options[:sort_dir] = order_dir
    session[:search_contact_params][:sort_col] = order_col
    session[:search_contact_params][:sort_dir] = order_dir

    "#{order_col.gsub(',', " #{order_dir},")} #{order_dir}"
  end

  def send_assigned_contacts_email(contacts)
    person = contacts.first.person
    # assume all contacts are assigned to one person
    if person && contacts.collect(&:person_id).uniq.length == 1 && contacts.first.person_id == person.id
      contacts.sort! { |a, b| a.priority <=> b.priority }
      ContactMailer.deliver_assigned_contacts_email(contacts, base_url) if person.present?
    end
  end
  
end
