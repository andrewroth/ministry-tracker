class MinistrySchoolYear < ActiveRecord::Base
  belongs_to :ministry
  has_many :terms
  
  #Ensures that this term year not overlap another
  def not_overlapping
    
  end
  
  def name
    self.start.year + "/" + self.end.year
  end
  
  def active
    (self.start > Time.now) && (self.end < Time.now)
  end
  
  def self.findActive
    MinistrySchoolYear.find(:first,
                            :conditions => [
                              "start < :now AND end > :now", 
                              {:now => Time.now}
                            ]
                           )
  end
  
  def self.findActive(ministry)
    MinistrySchoolYear.find(:first,
                            :conditions => [
                              "start < :now AND end > :now AND ministry_id = :ministry_id", 
                              {:now => Time.now, :ministry_id => ministry.id}
                           ]
                           )
  end
  
  def next
    MinistrySchoolYear.find(:first,
                            :conditions => [
                              "start > :end", {:end => this.end}
                           ],
                            :order => 'start')
  end
  
  def previous
    MinistrySchoolYear.find(:first,
                            :conditions => [
                           "end < :start", {:start => this.start}
                           ],
                            :order => 'start')
  end
end
