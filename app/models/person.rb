class Person < ActiveRecord::Base
  include ActiveRecord::ConnectionAdapters::Quoting
  load_mappings
  if $cache
    index _(:user_id)
    index _(:id)
  end
  
  # Campus Relationships
  has_many :campus_involvements #, :include => [:ministry, :campus]
  has_many :active_campus_involvements, :class_name => "CampusInvolvement", :foreign_key => _(:person_id), :conditions => {_(:end_date, :campus_involvement) => nil}
  has_many :campuses, :through => :campus_involvements, :order => Campus.table_name+'.'+_(:name, :campus)
  has_many :ministry_campuses_responsible_for, :class_name => "MinistryCampus", :foreign_key => "tree_head_id"
  belongs_to  :primary_campus_involvement, :class_name => "CampusInvolvement", :foreign_key => _(:primary_campus_involvement_id)
  # accepts_nested_attributes_for :primary_campus_involvement
  has_one  :primary_campus, :class_name => "Campus", :through => :primary_campus_involvement, :source => :campus
  has_many :active_ministry_involvements, :class_name => "MinistryInvolvement", :foreign_key => _(:person_id, :ministry_involvement), :conditions => {_(:end_date, :ministry_involvement) => nil}
  has_many :ministry_involvements, :class_name => "MinistryInvolvement", :foreign_key => _(:person_id, :ministry_involvement)
  has_many :ministries, :through => :active_ministry_involvements, :order => Ministry.table_name+'.'+_(:name, :ministry)
  has_many :campus_ministries, :through => :campus_involvements, :class_name => "Ministry", :source => :ministry
  has_one :responsible_person, :class_name => "Person", :through => :ministry_involvements
  has_many :involvements_responsible_for, :class_name => "MinistryInvolvement", :foreign_key => "responsible_person_id"
  has_many :people_responsible_for, :class_name => "Person", :through => :involvements_responsible_for, :source => :person
 
  
  
  # Address Relationships
  has_many :addresses, :class_name => "Address", :foreign_key => _(:person_id, :address)
  has_one :current_address, :class_name => "CurrentAddress", :foreign_key => _(:person_id, :address), :conditions => _(:address_type, :address) + " = 'current'"
  has_one :permanent_address, :class_name => "PermanentAddress", :foreign_key => _(:person_id, :address), :conditions => _(:address_type, :address) + " = 'permanent'"
  has_one :emergency_address, :class_name => "EmergencyAddress", :foreign_key => _(:person_id, :address), :conditions => _(:address_type, :address) + " = 'emergency1'"
  
  # Group Involvements
  # all
  has_many :all_group_involvements, :class_name => 'GroupInvolvement'
  has_many :all_groups, :through => :all_group_involvements, 
    :source => :group
  # no interested or requests
  has_many :group_involvements, :conditions => [
    _(:level, :group_involvement) + " IN ('leader', 'member', 'co-leader')",
    _(:requested, :group_involvement) + " != true"
  ]
  has_many :groups, :through => :group_involvements
  # interests
  has_many :group_involvement_interests, 
    :class_name => 'GroupInvolvement',
    :conditions => { 
      _(:level, :group_involvement) => 'interested',
      _(:requested, :group_involvement) => [ false, nil ]
    }
  has_many :group_interests, :through => :group_involvement_interests,
    :class_name => 'Group', :source => :group
  # requests
  has_many :group_involvement_requests,
    :class_name => 'GroupInvolvement',
    :conditions => { _(:requested, :group_involvement) => true }
  has_many :group_requests, :through => :group_involvement_requests,
    :class_name => 'Group', :source => :group
  has_many :promotions
  has_many :promotion_requests, :class_name => 'Promotion', :foreign_key => "promoter_id"
  
  def requests_responsible_for
  	requests = []
  	involvements = self.involvements_responsible_for
  	involvements.each do |involvement|
  		if involvement.promotion
  			requests << involvement.promotion
  		end
  	end
  	requests
  end
  
  def group_group_involvements(filter, options = {})
    case filter
    when :all
      gis = all_group_involvements
    when :involved
      gis = group_involvements
    when :interests
      gis = group_involvement_interests
    when :requests
      gis = group_involvement_requests
    end
    gis_grouped = gis.group_by { |gi| gi.group.group_type }
    if options[:ministry]
      gis_grouped.delete_if{ |gt, gis| 
        gt.ministry != options[:ministry]
      }
    end
    gis_grouped
  end


  # Conferences
  has_many :conference_registrations, :class_name => "ConferenceRegistration", :foreign_key => _(:person_id, :conference_registration)
  has_many :conferences, :through => :conference_registrations
  
  # STINTs
  has_many :stint_applications, :class_name => "StintApplication", :foreign_key => _(:person_id, :stint_application)
  has_many :stint_locations, :through => :stint_applications
  
  # Training Questions
  has_many :training_answers, :class_name => "TrainingAnswer", :foreign_key => _(:person_id, :training_answer)
  has_many :training_questions, :through => :training_answers

  # Users
  belongs_to :user, :class_name => "User", :foreign_key => _(:user_id)
  
  # Summer Projects
  has_many :summer_project_applications, :order =>  "#{SummerProjectApplication.table_name}.#{_(:created_at, :summer_project_application)}"
  has_many :summer_projects, :through => :summer_project_applications, :order => "#{SummerProject.table_name}.#{_(:created_at, :summer_project)} desc"
  
  # Custom Values
  has_many :custom_values, :class_name => "CustomValue", :foreign_key => _(:person_id, :custom_value)
  
  has_many :imports
  
  has_one :timetable, :class_name => "Timetable", :foreign_key => _(:person_id, :timetable)
  has_many :free_times, :through => :timetable, :order => "#{_(:day_of_week, :free_times)}, #{_(:start_time, :free_times)}"
  
  # Searches
  has_many :searches, :class_name => "Search", :foreign_key => _(:person_id, :search), :order => "#{_(:updated_at, :search)} desc"

  # Correspondences
  has_many :correspondences
  
  validates_presence_of _(:first_name)
  validates_presence_of _(:last_name), :on => :update
  # validates_presence_of _(:gender)
  
  validate :birth_date_is_in_the_past

  has_one :profile_picture, :class_name => "ProfilePicture", :foreign_key => _("person_id", :profile_picture)
  
  before_save :update_stamp
  before_create :create_stamp

#liquid_methods :first_name, :last_name
def to_liquid
    { "hisher" => hisher, "himher" => himher, "heshe" => heshe, "first_name" => first_name, "last_name" => last_name, "preferred_name" => preferred_name, "user" => user, "currentaddress" => current_address }
end


  # wrapper to make gender display nicely with crusade tables
  def human_gender(value = nil)
    gender = value || self.gender
    Person.human_gender(gender)
  end
  
  def self.human_gender(gender)
    if [0,1,'0','1'].include?(gender)
      gender = ((gender.to_s == '0') ? 'Female' : 'Male')
    end
    if ['M','F'].include?(gender)
      gender = gender == 'F' ? 'Female' : 'Male'
    end
    gender ? gender.titlecase : nil
  end
  
  def gender=(value)
    if value.present?
      self[:gender] = (male?(value) ? 1 : 0)
    end
  end
  
  def male?(value = nil)
    human_gender(value) == 'Male'
  end

  # genderization for personafication in templates
  def hisher
    hisher = human_gender == 'Male' ? 'his' : 'her'
  end

  def himher
    himher = human_gender == 'Male' ? 'him' : 'her'
  end

  def heshe
    heshe = human_gender == 'Male' ? 'he' : 'she'
  end
  
  def full_name
    first_name.to_s + ' ' + last_name.to_s
  end
  
  def custom_value_hash
    if @custom_value_hash.nil?
      @custom_value_hash = {}
      custom_values.each {|cv| @custom_value_hash[cv.custom_attribute_id] = cv.value }
    end
    @custom_value_hash
  end
  
  def training_answer_hash
    if @training_answer_hash.nil?
      @training_answer_hash = {}
      training_answers.each {|ta| @training_answer_hash[ta.training_question_id] = ta }
    end
  end
  
  def all_ministries
    (self.ministries + self.campus_ministries).uniq.sort
  end
  
  def ministry_tree
    @ministry_tree ||= (self.ministries.collect(&:ancestors).flatten + self.ministries.collect(&:descendants).flatten).uniq
  end
  
  def role(ministry)
    @roles ||= {}
    unless @roles[ministry]
      mi = ministry_involvements.find(:first, :conditions => "#{_(:person_id, :ministry_involvement)} = #{self.id} AND
                                                            #{_(:ministry_id, :ministry_involvement)} = #{ministry.id}")
      @roles[ministry] = mi ? mi.ministry_role : nil
    end
    @roles[ministry]
  end
  
  def admin?(ministry)
    mi = MinistryInvolvement.find(:first, :conditions => "#{_(:person_id, :ministry_involvement)} = #{self.id} AND
                                                          #{_(:ministry_id, :ministry_involvement)} IN (#{ministry.ancestor_ids.join(',')}) AND
                                                          #{_(:admin, :ministry_involvement)} = 1")
    return !mi.nil?
  end
  
  alias_method :get_custom_value_hash, :custom_value_hash
  alias_method :get_training_answer_hash, :training_answer_hash
  
  # Get the value of a custom_attribute
  def get_value(attribute_id)
    get_custom_value_hash
    return @custom_value_hash[attribute_id]
  end
  
  def get_training_answer(question_id)
    get_training_answer_hash
    return @training_answer_hash[question_id]
  end
  
  # Set the value of a custom_attribute
  def set_value(attribute_id, value)
    get_custom_value_hash
    if @custom_value_hash[attribute_id].nil?
      create_value(attribute_id, value)
    else
      if value && @custom_value_hash[attribute_id] != value
        sql = "UPDATE #{CustomValue.table_name} SET   #{Person::_(:value, :custom_value)} = '#{quote_string(value)}' 
                                                WHERE #{Person::_(:person_id, :custom_value)} = #{id} 
                                                AND   #{Person::_(:custom_attribute_id, :custom_value)} = #{attribute_id}"
        CustomValue.connection.execute(sql)
        @custom_value_hash[attribute_id] = value
      end
    end
    value
  end
  
  # Initialize the value of a custom_attribute
  def create_value(attribute_id, value)
    get_custom_value_hash
    sql = "INSERT INTO    #{CustomValue.table_name} (#{Person::_(:person_id, :custom_value)}, #{Person::_(:custom_attribute_id, :custom_value)}, 
                                                    #{Person::_(:value, :custom_value)})
                  VALUES  (#{id}, #{attribute_id}, '#{quote_string(value)}')"
    CustomValue.connection.execute(sql)
    @custom_value_hash[attribute_id] = value
  end
  
  # Set the value of a training_answer
  def set_training_answer(question_id, date, approver)
    get_training_answer_hash
    date = nil if date == ''
    if @training_answer_hash[question_id].nil? && date
      # Create a row for this answer
      answer = TrainingAnswer.create(_(:person_id, :training_answer) => id, _(:training_question_id, :training_answer) => question_id, 
                                      _(:completed_at, :training_answer) => date, _(:approved_by, :training_answer) => approver)
      @training_answer_hash[question_id] = answer
    elsif date
      approved_by = approver ? approver : @training_answer_hash[question_id].approved_by
      @training_answer_hash[question_id].update_attributes({_(:completed_at, :training_answer) => date, _(:approved_by, :training_answer) => approver})
    end
  end
  
  def initialize_addresses(types = nil)
    self.current_address ||= CurrentAddress.new
    self.permanent_address ||= PermanentAddress.new
    self.emergency_address ||= EmergencyAddress.new
  end
  
  def add_campus(campus_id, ministry_id, added_by, role = nil)
    unless role
      ministry = Ministry.find(ministry_id)
      student_roles = ministry.student_roles
      role = student_roles.first.id
    end
    # Make sure they're not already on this campus
    campus_involvement = CampusInvolvement.find_by_campus_id_and_person_id(campus_id, self.id)
    self.campus_involvements << CampusInvolvement.new(:campus_id => campus_id, :ministry_id => ministry_id, :added_by_id => added_by, :start_date => Time.now()) unless campus_involvement
    
    # Add the person to the ministry
    mi = MinistryInvolvement.find_by_ministry_id_and_person_id(ministry_id, self.id)
    unless mi
      self.ministry_involvements << MinistryInvolvement.new(:ministry_id => ministry_id, :ministry_role_id => role, :start_date => Time.now()) 
    end
  end
  
  def self.find_exact(person, address)
    # check based on username first
    user = User.find(:first, :conditions => ["#{_(:username, :user)} = ?", address.email])
    if user && user.person.nil?
      # If we have an orphaned user record, might as well use it...
      user.person = person
      person.save(false)
      p = person
    else
      p = user.person if user
    end
    unless p
      address = CurrentAddress.find(:first, :conditions => ["#{_(:email, :address)} = ?", address.email])
      p = address.person if address
      p.user ||= User.create!(_(:username, :user) => address.email) if p
    end
    return p
  end
  
  def import_gcx_profile(proxy_granting_ticket)
    service_uri = "https://www.mygcx.org/system/report/profile/attributes"
    proxy_ticket = CASClient::Frameworks::Rails::Filter.client.request_proxy_ticket(proxy_granting_ticket, service_uri).ticket
    ticket = CASClient::ServiceTicket.new(proxy_ticket, service_uri)
    return false unless proxy_ticket
    uri = "#{service_uri}?ticket=#{proxy_ticket}"
    logger.debug('URI: ' + uri)
    uri = URI.parse(uri) unless uri.kind_of? URI
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = (uri.scheme == 'https')
    raw_res = https.start do |conn|
      conn.get("#{uri}")
    end
    doc = Hpricot(raw_res.body)
    return false if (doc/'attribute').empty?
    (doc/'attribute').each do |attrib|
      if attrib['value'].present?
        current_address.email = attrib['value'].downcase if attrib['displayname'] == 'emailAddress' && current_address
        current_address.city = attrib['value'] if attrib['displayname'] == 'city' && current_address
        current_address.phone = attrib['value'] if attrib['displayname'] == 'landPhone' && current_address
        current_address.alternate_phone = attrib['value'] if attrib['displayname'] == 'mobilePhone' && current_address
        current_address.zip = attrib['value'] if attrib['displayname'] == 'zip' && current_address
        current_address.address1 = attrib['value'] if attrib['displayname'] == 'location' && current_address
        first_name = attrib['value'] if attrib['displayname'] == 'firstName'
        last_name = attrib['value'] if attrib['displayname'] == 'lastName'
        birth_date = attrib['value'] if attrib['displayname'] == 'birthdate'
        gender = attrib['value'] if attrib['displayname'] == 'gender'
      end
    end
    current_address.save(false) if current_address
    self.save(false)
  end
  
  def most_recent_involvement
    @most_recent_involvement ||= primary_campus_involvement || campus_involvements.last
  end
  
  protected
    def update_stamp
      self.updated_at = Time.now
      self.updated_by = 'MT'
    end
    
    def create_stamp
      update_stamp
      self.created_at = Time.now
      self.created_by = 'MT'
    end
    
  private

    def birth_date_is_in_the_past
      if !birth_date.nil?
        if (birth_date <=> Date.today) > 0
          errors.add(:birth_date, 'should be in the past')
        end
      end
    end
end  
