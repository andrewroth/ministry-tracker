class MinistryRole < ActiveRecord::Base
  load_mappings
  
  acts_as_list :scope => :ministry
  
  belongs_to :ministry
  has_many :ministry_role_permissions
  has_many :permissions, :through => :ministry_role_permissions
  has_many :ministry_involvements
  has_many :people, :through => :ministry_involvements
  
  validates_presence_of :name, :ministry_id, :type
  
  def <=>(other)
    self.position <=> other.position
  end
  
  def >=(other)
    self.position <= other.position
  end

  def self.human_name
    self.name.underscore.humanize
  end

  def self.default_student_role
    sr = StudentRole.find_by_name %w(Student student)
    sr ||= StudentRole.find :last, :order => "position"
  end

  def self.default_staff_role
    sr = StaffRole.find_by_name %w(Missionary missionary Staff staff)
    sr ||= StaffRole.find :last, :order => "position"
  end
end
