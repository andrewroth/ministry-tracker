class Ministry < ActiveRecord::Base
  load_mappings
  
  acts_as_tree :order => _(:name), :counter_cache => true
  
  belongs_to :parent, :class_name => "Ministry", :foreign_key => _(:parent_id)
  
  has_many :ministry_roles
  has_many :campus_involvements, :through => :ministry_roles
  # has_many :people, :through => :campus_involvements
  has_many :people, :through => :ministry_involvements
  has_many :staff, :through => :ministry_involvements, :source => :person, :conditions => "#{_(:ministry_role, :ministry_involvement)} IN ('Staff','Director')"
  has_many :ministry_campuses, :include => :campus #, :order => _(:name, 'campus')
  has_many :campuses, :through => :ministry_campuses, :order => _(:name, 'campus')
  has_many :ministry_involvements, :dependent => :destroy
  has_many :user_groups, :order => _(:name, 'user_group')
  has_many :groups
  has_many :bible_studies
  has_many :teams
  has_many :custom_attributes
  has_many :profile_questions
  has_many :involvement_questions
  has_many :training_categories, :class_name => "TrainingCategory", :foreign_key => _(:ministry_id, :training_category), :order => _(:position, :training_category)
  has_many :training_questions, :order => "activated, activity"
  has_many :views, :order => View.table_name + '.' + _(:title, 'view')
  
  
  validates_presence_of _(:name)
  # validates_presence_of _(:address), :message => "can't be blank"
  # validates_presence_of _(:city), :message => "can't be blank"
  # validates_presence_of _(:state), :message => "can't be blank"
  # validates_presence_of _(:country), :message => "can't be blank"
  # validates_presence_of _(:phone)
  # validates_presence_of _(:email)
  
  validates_uniqueness_of _(:name)
  
  after_create :create_first_view
  
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
    unless @root
      @root = self.parent ? self.parent.root : self
    end
    return @root
  end
  
  def root?
    self.parent_id.nil?
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
    view = View.find(:first)
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
end
