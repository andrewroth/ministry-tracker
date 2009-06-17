class Term < ActiveRecord::Base
  belongs_to :ministry_school_year
  has_many :campus_terms
  
  validates_presence_of :ministry_school_year
  validate_on_update :has_end_and_start
  validate :is_during_school_year
  validate :start_is_after_end
  validate :not_overlapping
  
  def active
    (self.start > Time.now) && (self.end < Time.now)
  end
  
  def self.findActive
    Term.find(:first,
              :conditions => [
                "start < :now AND end > :now", 
                {:now => Time.now}
                ]
              )
  end
  
  def self.findActive(ministry)
    Term.find(:first,
              :conditions => [
                "start < :now AND end > :now AND ministry_id = :ministry_id", 
                {:now => Time.now, :ministry_id => ministry.id}
              ]
              )
  end
  
  def self.findLast
    Term.first(:order => 'end DESC')
  end
  
  def self.findFirst
    Term.first(:order => 'start')
  end
  
  def next
    Term.first(:conditions => [
        "start >= :end AND end IS NOT NULL", {:end => self.end}
      ],
      :order => 'start')
  end
  
  def previous
    prev = Term.first(:conditions => [
      "end <= :start AND start IS NOT NULL", {:start => self.start}
      ],
      :order => 'start DESC') if self.start
    
    #If the term doesn't have a starting date, then it likely is in the future
    #ergo the previous term is the last term chronologically
    prev = Term.findLast unless self.start
    
    prev
  end
  
  private
  
  def start_is_after_end
    if self.start && self.end
      errors.add(:start, "Starting date should be before ending date") unless (self.start < self.end)
    end
  end
  
  #Ensures that this term year not overlap another
  def not_overlapping
    if self.end && self.start
      if Term.first(:conditions => ["(start > :start AND start < :end) OR (end > :start AND end < :end) OR (start <= :start AND end >= :end)", {:start => self.start, :end => self.end} ])
        errors.add_to_base "Term must not overlap with an existing term."
      end
    end
  end
  
  def has_end_and_start
    errors.add(:start, "must have both a starting date") unless self.start
    errors.add(:end, "must have both a ending date") unless self.end
  end
  
  def is_during_school_year
    errors.add(:start, "may not start before the school year") if self.start && ministry_school_year.start < self.start
    errors.add(:end, "may not end after the school year") if self.end && ministry_school_year.end > self.end
  end
end
