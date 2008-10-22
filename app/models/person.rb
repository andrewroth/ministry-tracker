class Person < ActiveRecord::Base
  load_mappings
  
  # Campus Relationships
  has_many :campus_involvements, :include => [:ministry, :campus]
  has_many :campuses, :through => :campus_involvements, :order => Campus.table_name+'.'+_(:name, :campus)
  has_many :ministry_involvements, :include => :ministry, :order => Ministry.table_name+'.'+_(:name, :ministry), :class_name => "MinistryInvolvement", :foreign_key => _(:person_id, :ministry_involvement)
  has_many :ministries, :through => :ministry_involvements, :order => Ministry.table_name+'.'+_(:name, :ministry)
  has_many :campus_ministries, :through => :campus_involvements, :class_name => "Ministry", :source => :ministry

  # Address Relationships
  has_many :addresses, :class_name => "Address", :foreign_key => _(:person_id, :address)
  has_one :current_address, :class_name => "CurrentAddress", :foreign_key => _(:person_id, :address), :conditions => _(:address_type, :address) + " = 'current'"
  has_one :permanent_address, :class_name => "PermanentAddress", :foreign_key => _(:person_id, :address), :conditions => _(:address_type, :address) + " = 'permanent'"
  has_one :emergency_address, :class_name => "EmergencyAddress", :foreign_key => _(:person_id, :address), :conditions => _(:address_type, :address) + " = 'emergency1'"
  
  # Group Involvements  
  has_many :group_involvements
  has_many :groups, :through => :group_involvements
  
  has_many :bible_studies, :through => :group_involvements, :conditions => _(:level, :group_involvement) + " IN ('leader', 'member')"
  has_many :teams, :through => :group_involvements
  
  has_many :team_involvements, :through => :group_involvements, :source => :team,
                               :conditions => _(:level, :group_involvement) + " IN ('leader', 'member')"
  
  has_many :team_interests, :through => :group_involvements, :source => :team, 
                            :conditions => _(:level, :group_involvement) + " = 'interested'"
                            
  # Summer Projects
  has_many :summer_project_applications, :class_name => "SummerProjectApplication", :foreign_key => _(:person_id, :summer_project_application)
  has_many :summer_projects, :through => :summer_project_applications
  
  # Conferences
  has_many :conference_registrations, :class_name => "ConferenceRegistration", :foreign_key => _(:person_id, :conference_registration)
  has_many :conferences, :through => :conference_registrations
  
  # STINTs
  has_many :stint_applications, :class_name => "StintApplication", :foreign_key => _(:person_id, :stint_application)
  has_many :stint_locations, :through => :stint_applications
  
  # Training Questions
  has_many :training_answers, :class_name => "TrainingAnswer", :foreign_key => _(:person_id, :training_answer)
  has_many :training_questions, :through => :training_answers
              
  belongs_to :user, :class_name => "User", :foreign_key => _(:user_id)
  
  # Conferences
  has_many :conference_registrations, :class_name => 'ConferenceRegistration', :foreign_key => _(:person_id, :conference_registration)
  has_many :conferences, :through => :conference_registrations, :order => Conference.table_name + '.' + _(:name, :conference)
  # 
  # Summer Projects
  has_many :summer_project_applications
  has_many :summer_projects, :through => :summer_project_applications, :order => SummerProject.table_name + '.' + _(:name, :summer_project), :conditions => SummerProjectApplication.table_name + '.' + _(:status, :summer_project_application) + " = 'accepted'"
  
  # Custom Values
  has_many :custom_values, :class_name => "CustomValue", :foreign_key => _(:person_id, :custom_value)
  
  has_many :imports
    
  validates_presence_of _(:first_name)
  validates_presence_of _(:last_name)
  # validates_presence_of _(:gender)
  # 
  # file_column _(:image), :fix_file_extensions => true,
  #                         :magick => { :size => '400x400!', :crop => '1:1',
  #                           :versions => {
  #                             :mini   => {:crop => '1:1', :size => "50x50!"},
  #                             :thumb  => {:crop => '1:1', :size => "100x100!"},
  #                             :medium => {:crop => '1:1', :size => "200x200!"}
  #                           }
  #                         }

  has_one :profile_picture, :class_name => "ProfilePicture", :foreign_key => _("person_id", :profile_picture)
  
  before_save :update_stamp
  before_create :create_stamp
  
  
  # wrapper to make gender display nicely with crusade tables
  def human_gender(value = nil)
    gender = value || self.gender
    if [0,1,'0','1'].include? gender
      @gender = ((gender.to_s == '0') ? 'Female' : 'Male')
    end
    if ['M','F'].include? gender
      @gender = gender == 'F' ? 'Female' : 'Male'
    end
    @gender || gender
  end
  
  def gender=(value)
    self[:gender] = (male?(value) ? 1 : 0)
  end
  
  def male?(value = nil)
    human_gender(value) == 'Male'
  end
  
  def full_name
    first_name + ' ' + last_name
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
        sql = "UPDATE #{CustomValue.table_name} SET   #{Person::_(:value, :custom_value)} = '#{ApplicationController::escape_string(value)}' 
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
                  VALUES  (#{id}, #{attribute_id}, '#{ApplicationController::escape_string(value)}')"
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
  
  def add_campus(campus_id, ministry_id)
    # Make sure they're not already on this campus
    campus_involvement = CampusInvolvement.find_by_campus_id_and_person_id(campus_id, self.id)
    self.campus_involvements << CampusInvolvement.new(:campus_id => campus_id, :ministry_id => ministry_id, :ministry_role => 'Student', :start_date => Time.now()) unless campus_involvement
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
  
  protected
    def update_stamp
      updated_at = Time.now
      updated_by = 'MT'
    end
    
    def create_stamp
      update_stamp
      created_at = Time.now
      created_by = 'MT'
    end
end  
