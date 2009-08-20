class Ministry < ActiveRecord::Base
  load_mappings
  if $cache
    index _(:id) 
    index _(:parent_id)
  end
  
  # acts_as_tree :order => _(:name), :counter_cache => true
  has_many :children, :class_name => "Ministry", :foreign_key => _(:parent_id), 
    :order => "#{Ministry.table_name}.`#{_(:name)}"
  
  belongs_to :parent, :class_name => "Ministry", :foreign_key => _(:parent_id)
  
  has_many :permissions, :through => :ministry_roles, :source => :ministry_role_permissions
  # note - dependent is removed since these role methods are overridden
  #  to return the root ministry's roles as well, meaning the root ministry's
  #  roles were also being deleted!
  has_many :ministry_roles, :order => _(:position, :ministry_role)
  has_many :student_roles, :order => _(:position, :ministry_role)
  has_many :staff_roles, :order => _(:position, :ministry_role)
  has_many :other_roles, :order => _(:position, :ministry_role)   
  has_many :campus_involvements
  # has_many :people, :through => :campus_involvements
  has_many :people, :through => :ministry_involvements
  has_many :ministry_campuses, :include => :campus, :dependent => :destroy, 
    :include => :campus, :order => _(:name, :campus)
  has_many :campuses, :through => :ministry_campuses, :order => _(:name, 'campus')
  has_many :ministry_involvements, :dependent => :destroy, :dependent => :destroy
  has_many :groups, :dependent => :destroy
  has_many :group_types, :class_name => "GroupType", :foreign_key => _(:ministry_id, :group_type)
  has_many :custom_attributes, :dependent => :destroy
  has_many :profile_questions, :dependent => :destroy
  has_many :involvement_questions, :dependent => :destroy
  has_many :training_categories, :class_name => "TrainingCategory", :foreign_key => _(:ministry_id, :training_category), :order => _(:position, :training_category), :dependent => :destroy
  has_many :training_questions, :order => "activity", :dependent => :destroy
  has_many :views, :order => View.table_name + '.' + _(:title, 'view'), :dependent => :destroy
  
  has_many :training_question_activations
  has_many :active_training_questions, :through => :training_question_activations, :source => :training_question
  
  has_many :group_types
  
  
  validates_presence_of _(:name)
  
  validates_uniqueness_of _(:name)
  
  after_create :create_first_view, :create_default_roles
  
  alias_method :my_ministry_roles, :ministry_roles
  alias_method :my_staff_roles, :staff_roles
  alias_method :my_student_roles, :student_roles
  alias_method :my_other_roles, :other_roles
  
  def all_group_types
    @all_group_types ||= GroupType.find(:all, :conditions => ["ministry_id IN (?)", ancestor_ids], :order => _(:group_type, :group_type))
  end 
  
  def staff
    @staff ||= Person.find(:all, :conditions => ["#{_(:ministry_role_id, :ministry_involvement)} IN (?) AND #{_(:ministry_id, :ministry_involvement)} IN (?)", staff_role_ids, ancestor_ids], :joins => :ministry_involvements)
  end
  
  def ministry_roles
    self.root? ? my_ministry_roles : self.root.my_ministry_roles
  end
  
  def staff_roles
    self.root? ? my_staff_roles : self.root.my_staff_roles
  end
  
  def student_roles
    self.root? ? my_student_roles : self.root.my_student_roles
  end
  
  def other_roles
    self.root? ? my_other_roles : self.root.my_other_roles
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
    unless @campus_ids
      ministry_ids = ([self] + descendants).collect(&:id)
      sql = "SELECT #{_(:campus_id, :ministry_campus)} FROM #{MinistryCampus.table_name} WHERE #{_(:ministry_id, :ministry_campus)} IN(#{ministry_ids.join(',')})"
      @campus_ids = ActiveRecord::Base.connection.select_values(sql).collect(&:to_i)
    end
    @campus_ids
  end
  
  def descendants
    unless @descendants
      @offspring = self.children.find(:all, :include => :children)
      @descendants = @offspring.dup
      @offspring.each do |ministry|
          @descendants += ministry.descendants unless ministry.children.count.to_i == 0 || ministry == self
        end
      @descendants.sort!
    end
    return @descendants
  end
  
  def mandated_training_questions
    @mandated_training_questions = TrainingQuestionActivation.find(:all, :conditions => ["mandate = 1 AND #{_(:ministry_id, :training_question_activation)} IN(?)", ancestor_ids], :include => :training_question).collect(&:training_question)
  end
  
  def self_mandated_training_questions
    @self_mandated_training_questions = TrainingQuestionActivation.find(:all, :conditions => ["mandate = 1 AND #{_(:ministry_id, :training_question_activation)} = ?", self.id], :include => :training_question).collect(&:training_question)
  end
  
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
    @staff_role_ids ||= staff_roles.find(:all).collect(&:id)
  end
  
  def student_role_ids
    @student_role_ids ||= student_roles.collect(&:id)
  end
  
  def involved_student_roles
    @involved_student_roles ||= StudentRole.find(:all, :conditions => { _(:involved, :ministry_roles) => true })
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
    # copy the first view in the system if there is one
    view = View.find(:first, :order => _(:ministry_id, :view))
    if view
      new_view = view.clone
      views << view
      view.view_columns.each do |view_column|
        new_view.view_columns << view_column.clone
      end
    #if that doesn't exist, make a new view will every column
    else
      new_view = View.new(:title => "default", :ministry_id => self.id)
      Column.all.each do |c|
        new_view.columns.create!  :column_id => c.id
      end
    end
    new_view.default_view = true
    new_view.save!
    new_view
  end
  
  # Training categories including all the categories higher up on the tree
  def all_training_categories
    @all_training_categories ||= Array.wrap(ancestors.collect(&:training_categories)).flatten.uniq
    return @all_training_categories
  end  
  
  # Training questions including all the questions higher up on the tree
  def all_training_questions
    @all_training_questions ||= Array.wrap(ancestors.collect(&:training_questions)).flatten.uniq
    return @all_training_questions
  end
  
  protected

  def before_destroy
    my_ministry_roles.each do |mr|
      mr.destroy
    end
  end

  # TODO this should use the seed instead of recreating it inline here
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
