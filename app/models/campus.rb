class Campus < ActiveRecord::Base
  load_mappings
  
  has_many :campus_involvements
  has_many :people, :through => :campus_involvements
  has_many :groups
  has_many :bible_studies
  has_many :ministry_campuses, :include => :ministry
  has_many :ministries, :through => :ministry_campuses, :order => Ministry.table_name+'.'+_(:name, :ministry)
  has_many :dorms
  
  def short_name
    self.abbrv.to_s.empty? ? self.name : self.abbrv
  end
  
  def <=>(other)
    name <=> other.name
  end
end
