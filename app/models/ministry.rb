class Ministry < ActiveRecord::Base
  load_mappings
  
  acts_as_tree :order => _(:name), :counter_cache => true
  
  belongs_to :parent, :class_name => "Ministry", :foreign_key => _(:parent_id)
  
  has_many :ministry_roles, :dependent => :destroy, :order => _(:position, :ministry_role)
  has_many :permissions, :through => :ministry_roles, :source => :ministry_role_permissions
  has_many :student_roles, :dependent => :destroy, :order => _(:position, :ministry_role)
  has_many :staff_roles, :dependent => :destroy, :order => _(:position, :ministry_role)
  has_many :other_roles, :dependent => :destroy, :order => _(:position, :ministry_role)   
  has_many :campus_involvements, :through => :ministry_roles
  # has_many :people, :through => :campus_involvements
  has_many :people, :through => :ministry_involvements
  has_many :ministry_campuses, :include => :campus, :dependent => :destroy
  has_many :campuses, :through => :ministry_campuses, :order => _(:name, 'campus')
  has_many :ministry_involvements, :dependent => :destroy, :dependent => :destroy
  has_many :groups, :dependent => :destroy
  has_many :bible_studies, :dependent => :destroy
  has_many :teams, :dependent => :destroy
  has_many :custom_attributes, :dependent => :destroy
  has_many :profile_questions, :dependent => :destroy
  has_many :involvement_questions, :dependent => :destroy
  has_many :training_categories, :class_name => "TrainingCategory", :foreign_key => _(:ministry_id, :training_category), :order => _(:position, :training_category), :dependent => :destroy
  has_many :training_questions, :order => "activated, activity", :dependent => :destroy
  has_many :views, :order => View.table_name + '.' + _(:title, 'view'), :dependent => :destroy
  
  
  validates_presence_of _(:name)
  # validates_presence_of _(:address), :message => "can't be blank"
  # validates_presence_of _(:city), :message => "can't be blank"
  # validates_presence_of _(:state), :message => "can't be blank"
  # validates_presence_of _(:country), :message => "can't be blank"
  # validates_presence_of _(:phone)
  # validates_presence_of _(:email)
  
  validates_uniqueness_of _(:name)
  
  after_create :create_first_view, :create_default_roles
  
  alias_method :root_ministry_roles, :ministry_roles
  alias_method :root_staff_roles, :staff_roles
  alias_method :root_student_roles, :student_roles
  alias_method :root_other_roles, :other_roles
  
  def staff
    @staff ||= Person.find(:all, :conditions => ["#{_(:ministry_role_id, :ministry_involvement)} IN (?) AND #{_(:ministry_id, :ministry_involvement)} = ?", staff_role_ids, self.id], :joins => :ministry_involvements)
  end
  
  def ministry_roles
    self.root? ? root_ministry_roles : self.root.root_ministry_roles
  end
  
  def staff_roles
    self.root? ? root_staff_roles : self.root.root_staff_roles
  end
  
  def student_roles
    self.root? ? root_student_roles : self.root.root_student_roles
  end
  
  def other_roles
    self.root? ? root_other_roles : self.root.root_other_roles
  end
  
  def subministry_campuses(top = true)
    unless @subministry_campuses
      @subministry_campuses = top ? [] : self.ministry_campuses
      self.children.each do |ministry|
        @subministry_campuses += ministry.subministry_campuses(false)
      end
    end
    return @subministry_campuses
  end
  
  def unique_campuses
    unless @unique_campuses
      @unique_ministry_campuses = ministry_campuses.clone
      @unique_campuses = campuses.clone
      subministry_campuses.each do |mc| 
        @unique_ministry_campuses << mc unless @unique_campuses.include?(mc.campus)
        @unique_campuses << mc.campus
      end
    end
    return @unique_ministry_campuses
  end
  
  def ancestors
    unless @ancestors
      @ancestors = parent ? [self, parent.ancestors] : [self]
      @ancestors.flatten!
    end
    @ancestors
  end
  
  def ancestor_ids
    @ancestor_ids ||= ancestors.collect(&:id)
  end
  
  def campus_ids
    unique_campuses.collect {|mc| mc.campus.id}
  end
  
  def descendants
    @descendants = self.children
    self.children.each do |ministry|
        @descendants += ministry.descendants unless ministry == self
      end
    @descendants.sort!
    return @descendants
  end
  
  # def children
  #     @children = self.children
  #     @children.sort!
  # end
  
  def root
    @root ||= self.parent_id ? self.parent.root : self
  end
  
  def root?
    self.parent_id.nil?
  end
  
  def leader_roles
    @leader_roles ||= staff_roles
  end
  
  def leader_roles_ids
    @leader_roles_ids ||= leader_roles.collect(&:id)
  end
  
  def staff_role_ids
    @staff_role_ids ||= staff_roles.collect(&:id)
  end
  
  def student_role_ids
    @student_role_ids ||= student_roles.collect(&:id)
  end
  
  def involved_student_roles
    @involved_student_roles ||= ministry_roles.find(:all, :conditions => "#{_(:position, :ministry_role)} >= 4 AND #{_(:position, :ministry_role)} < 11")
  end
  
  def involved_student_role_ids
    @involved_student_role_ids ||= involved_student_roles.collect(&:id)
  end
  
  def all_ministries
    (self.descendants + [self]).sort
  end
  
  def deleteable?
    !self.root? && self.children.count.to_i == 0
  end
  
  def <=>(ministry)
    self.name <=> ministry.name
  end
  
  # Create a default view for this ministry
  def create_first_view
    # For now just copy the first view in the system if there is one
    view = View.find(:first, :order => _(:ministry_id, :view))
    new_view = view.clone
    views << view
    view.view_columns.each do |view_column|
      new_view.view_columns << view_column.clone
    end
    new_view.default_view = true
    new_view.save!
    new_view
  end
  
  # Training categories including all the categories higher up on the tree
  def all_training_categories
    @all_training_categories ||= [training_categories + ancestors.collect(&:training_categories)].flatten.uniq
    return @all_training_categories
  end  
  
  # Training questions including all the questions higher up on the tree
  def all_training_questions
    @all_training_questions ||= [training_questions + ancestors.collect(&:training_questions)].flatten.uniq
    return @all_training_questions
  end
  
  protected
  def create_default_roles
    if self.root?
      self.ministry_roles << MinistryRole.create(_(:name, :ministry_role) => 'Campus Coordinator', _(:position, :ministry_role) => 2)
      self.ministry_roles << MinistryRole.create(_(:name, :ministry_role) => 'Ministry Leader', _(:position, :ministry_role) => 4, :description => 'a student who oversees a campus, eg LINC leader')
      self.ministry_roles << MinistryRole.create(_(:name, :ministry_role) => 'Missionary', _(:position, :ministry_role) => 3)
      self.ministry_roles << MinistryRole.create(_(:name, :ministry_role) => 'Student Leader', _(:position, :ministry_role) => 5)
      self.ministry_roles << MinistryRole.create(_(:name, :ministry_role) => 'Involved Student', _(:position, :ministry_role) => 6, :description => 'we are saying has been attending events for at least 6 months')
      self.ministry_roles << MinistryRole.create(_(:name, :ministry_role) => 'Student', _(:position, :ministry_role) => 7)
      self.ministry_roles << MinistryRole.create(_(:name, :ministry_role) => 'Registration Incomplete', _(:position, :ministry_role) => 8, :description => 'A leader has registered them, but user has not completed rego and signed the privacy policy')
      self.ministry_roles << MinistryRole.create(_(:name, :ministry_role) => 'Approval Pending', _(:position, :ministry_role) => 9, :description => 'They have applied, but a leader has not verified their application yet')
      self.ministry_roles << MinistryRole.create(_(:name, :ministry_role) => 'Honourary Member', _(:position, :ministry_role) => 10, :description => 'not a valid student or missionary, but we are giving them limited access anyway')
      self.ministry_roles << MinistryRole.create(_(:name, :ministry_role) => 'Admin', _(:position, :ministry_role) => 1)
    end
  end
end
