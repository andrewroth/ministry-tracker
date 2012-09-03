module ContactsHelper

  def options_corr(option)
    @options_corr || @options_corr = {}
    unless @options_corr.has_key?(option)
      @options_corr[option] = {}
      contact_options_lists[option].each do |a|
        @options_corr[option][a[1]] = a[0]
      end
    end
    @options_corr[option]
  end

  def contact_options_lists
    {
      :gender_id => [["Male", 2], ["Female", 1], ["Not Specified", 0]],
      :status => [["Uncontacted", 0], ["Attempted", 1], ["Contacted", 4], ["Completed", 2], ["Do Not Contact", 3]],
      :result => [["No Result Yet", 0], ["Bad Information", 1], ["No Response", 2], ["No Longer Interested", 3], ["Additional Digital Sent", 4], ["Magazine Grab 'n' Go", 5], ["Interaction", 6], ["Interaction & Magazine", 7]]
    }
  end

  #content for search options inputs
  def contact_search_options
    {
      :gender_id =>
      {
        :field => :gender_id,
        :title => "Gender",
        :options => contact_options_lists[:gender_id].insert(0, ["All", 9]),
        :default => 9
      },
      :priority =>
      {
        :field => :priority,
        :title => "Priority",
        :options =>  ["All", "Hot", "Medium", "Mild", "Not Interested"],
        :default => "All"
      },
      :assign =>
      {
        :field => :assign,
        :title => "Assign",
        :options =>  ["All", "Assigned", "Unassigned"],
        :default => "All"
      },
      :status =>
      {
        :field => :status,
        :title => "Status",
        :options =>  contact_options_lists[:status].insert(0, ["All", 9]),
        :default => 9
      },
      :result =>
      {
        :field => :result,
        :title => "Result",
        :options => contact_options_lists[:result].insert(0, ["All", 9]),
        :default => 9
      },
      :assigned_to =>
      {
        :field => :assigned_to,
        :title => "Assignee",
        :options => people_available_for_search,
        :default => -1
      }
    }
  end
  
  def contact_search_screen_fields
    [
      contact_search_options[:gender_id], 
      contact_search_options[:priority], 
      contact_search_options[:assign], 
      contact_search_options[:status], 
      contact_search_options[:result] , 
      contact_search_options[:assigned_to]
    ]
  end

  def contact_search_results_columns
    [
      { :display => "First Name",  :fields => ['first_name'] },
      { :display => "Last Name",   :fields => ['last_name'] },
      { :display => "Sex",         :fields => [contact_search_options[:gender_id][:field].to_s] },
      { :display => "Cellphone",   :fields => ['cellphone'] },
      { :display => "Year",        :fields => ['year'] },
      { :display => "Priority",    :fields => ['priority'] },
      { :display => "Assigned To", :fields => [Person._(:first_name), Person._(:last_name)] },
      { :display => "Status",      :fields => [contact_search_options[:status][:field].to_s]},
      { :display => "Result",      :fields => [contact_search_options[:result][:field].to_s] }
    ]
  end
  
  
  def interest_to_chat
    mapping = { 0 => "No answer", 1 => "Not Interested", 2 => "Maybe Not", 3 => "Maybe", 4 => "Yes", 5 => "Very Interested" }
    mapping[@contact[:interest]]
  end
  
  def contact_gender(contact = nil)
    if contact.nil?
      #used in edit view
      mapping = { 0 => "Gender Not Specified", 1 => "Female", 2 => "Male" }
      contact = @contact
    else
      #used in search view
       mapping = { 0 => "?", 1 => "F", 2 => "M" }
    end
    contact[:gender_id] ? mapping[contact[:gender_id]] : mapping[0]
  end
 
  def contact_status(contact = nil)
    contact || contact = @contact
    options_corr(:status)[contact[:status]]
  end 
 
  def contact_result(contact = nil)
    contact || contact = @contact
    options_corr(:result)[contact[:result]]
  end 
 
  def assigned_to(contact = nil)
    result = "Unassigned"
    if contact.nil?
      result = select_tag "assign", options_for_select(people_available, @contact[:person_id].nil? ? 0 : @contact[:person_id])
    elsif contact[:person_id].nil? == false
      unless contact[:person_id] == 0
        volunteer = contact.person
        result = "#{volunteer[:person_fname]} #{volunteer[:person_lname]}" unless volunteer.nil?
      end
    end
    result
  end

  def search_result_string
    so = ""
    [:gender_id, :status, :result].each do |f|
    if @search_options.has_key?(f)
      so = "#{so} #{contact_search_options[f][:title].lowercase}: #{@search_options[f].collect{ |o| options_corr(f)[o] }.join(',')}"
    end
    end
    "Contacts matching #{so} in #{campus[:campus_desc]}, #{@contacts.count} result#{ (@contacts.count == 1 ? '' : 's') } found"
  end

  def campus
    @campus ||=  Campus.find(@campus_id) unless @campus_id.nil?
    @campus
  end

  def campuses(with_ministry_roles = nil)
    @campuses || @me.campuses_under_my_ministries_with_children(with_ministry_roles)
  end
  
  def campuses_options(with_ministry_roles = nil)
    campuses(with_ministry_roles).collect{|c| [c[:campus_desc], c[:campus_id]]}
  end

  def people_available
    @people_available
  end

  def people_available_for_search
    @people_available_for_search
  end
  
  def convert_values(a, field)
    ans = a
    if a.kind_of?(Array) && contact_options_lists.has_key?(field)
      ans = []
      a.each do |v|
        ans.push(options_corr(field)[v])
      end
    end
    ans
  end
  
  def default_value(field)
    result = nil
    result = contact_search_options[field][:default] if contact_search_options.has_key?(field)
    result = @search_options[field] if @search_options.has_key?(field)
    result = result.collect{|d| is_number?(d) ? d.to_i : d } if result.is_a?(Array)
    result
  end
    
  def print_def(d)
    val = d
    if val.nil?
      val = "nil"
    elsif val.kind_of?(Array)
      res = "[\"#{val.join('", "')}\"]"
      val = res
    else
      val = val.to_s
    end
    val 
  end 

  def to_or_sentence(string)
    string.to_sentence(:last_word_connector => ', or ', :two_words_connector => ' or ')
  end

  def contact_campuses_options_for_select(campus_id)
    options_for_select(campuses_options(::MinistryRole::ministry_roles_that_grant_access("contacts", "index")), campus_id.present? ? campus_id.to_i : nil)
  end

  def is_number?(object)
    true if Float(object) rescue false
  end

  def link_to_contact_search_column_header(column, params)
    params[:sort_dir] ||= ''
    col = column[:fields].join(',')

    dir = case params[:sort_dir].upcase
    when 'ASC'
      params[:sort_col] == col.to_s ? 'DESC' : Contact::DEFAULT_SORT_DIRECTION
    when 'DESC'
      params[:sort_col] == col.to_s ? 'ASC'  : Contact::DEFAULT_SORT_DIRECTION
    else
      Contact::DEFAULT_SORT_DIRECTION
    end

    link_class = params[:sort_col] == col.to_s ? dir.downcase : ''

    link_to column[:display], params.merge(:sort_dir => dir, :sort_col => col), :class => link_class
  end

end
