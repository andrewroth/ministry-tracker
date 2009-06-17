class MinistrySchoolYear < ActiveRecord::Base
  belongs_to :ministry
  has_many :terms
  
  validates_presence_of :start, :end, :ministry
  validate_on_update :has_end_and_start
  validate :start_is_after_end
  validate :not_overlapping
  validate :does_not_invalidate_terms
  
  def name
    name = self.start.year.to_s if self.start 
    name << "/" if self.start && self.end
    name << self.end.year.to_s if self.end
    
    name ||= "New Year"
  end
  
  def active
    (self.start > Time.now) && (self.end < Time.now)
  end
  
  def self.findActive
    MinistrySchoolYear.first(:conditions => [
                              "start <= :now AND end >= :now", 
                              {:now => Time.now}
                            ]
                           )
  end
  
  def self.findActive(ministry)
    MinistrySchoolYear.first(:conditions => [
                              "start <= :now AND end >= :now AND ministry_id = :ministry_id", 
                              {:now => Time.now, :ministry_id => ministry.id}
                           ]
                           )
  end
  
  def self.findLast
    MinistrySchoolYear.first(:order => 'end DESC')
  end
  
  def self.findFirst
    MinistrySchoolYear.first(:order => 'start')
  end
  
  def next
    MinistrySchoolYear.first(:conditions => [
                             "ministry_id = :ministry_id AND start >= :end AND end IS NOT NULL", {:end => self.end, :ministry_id => self.ministry_id}
                           ],
                            :order => 'start')
  end
  
  def previous
    prev = MinistrySchoolYear.first(:conditions => [
                           "ministry_id = :ministry_id AND end <= :start AND start IS NOT NULL", {:start => self.start, :ministry_id => self.ministry_id}
                           ],
                            :order => 'start DESC') if self.start
    
    prev = MinistrySchoolYear.findLast unless self.start
    
    prev
  end
  
  private
  
  def start_is_after_end
    if self.start && self.end
      errors.add(:start, " date should be before ending date") unless (self.start < self.end)
    end
  end
  
  #Ensures that this term year not overlap another
  def not_overlapping
    if self.end && self.start
      if MinistrySchoolYear.first(:conditions => ["(ministry_id = :ministry_id) AND ((start > :start AND start < :end) OR (end > :start AND end < :end) OR (start <= :start AND end >= :end))", {:start => self.start, :end => self.end, :ministry_id => self.ministry_id } ])
        errors.add_to_base "School Year must not overlap with an existing school year."
      end
    end
  end
  
  def has_end_and_start
    errors.add(:start, "must have both a starting date") unless self.start
    errors.add(:end, "must have both a ending date") unless self.end
  end
  
  def does_not_invalidate_terms
    valid = false
    terms.each do |t|
      valid ||= t.valid?
    end
    errors.add("This change would invalidate one of the terms.  Please double check the dates") unless valid
  end
end
