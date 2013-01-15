class Contact < ActiveRecord::Base
  load_mappings

  has_and_belongs_to_many :people
  belongs_to :campus
  has_many :notes, :as => :noteable
  has_many :activities, :as => :reportable

  before_create :set_default_attributes

  validates_presence_of :first_name
  validates_presence_of :campus_id
  validates_presence_of :gender_id

  NEXT_STEP_OPTIONS = [["Unknown", 0], ["Know and trust a Christian", 1], ["Become curious", 2], ["Become open to change", 3], ["Seek God", 4], ["Make a decision", 5], ["Grow in relationship with God", 6]]

  named_scope :active, :conditions => { :active => true }
  named_scope :with_campus_id, lambda { |campus_id| { :conditions => { :campus_id => campus_id } } }


  def full_name
    "#{first_name} #{last_name}"
  end

  def next_step
    next_step_id ? NEXT_STEP_OPTIONS[next_step_id][0] : NEXT_STEP_OPTIONS[0][0]
  end

  def person
    people.first
  end

  def last_touched_at
    [activities.try(:collect, &:updated_at).try(:max), notes.try(:collect, &:updated_at).try(:max), updated_at].compact.max
  end


  private

  def set_default_attributes
    self.active = true
    self.private = true
  end
end