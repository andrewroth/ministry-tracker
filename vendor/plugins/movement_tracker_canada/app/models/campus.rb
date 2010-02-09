require_model 'campus'

class Campus < ActiveRecord::Base
  unloadable
  load_mappings

  belongs_to :region, :foreign_key => :region_id
  belongs_to :state, :foreign_key => _(:state_id)
  has_many :weekly_reports, :class_name => 'Weeklyreport', :foreign_key => _(:id)
  has_many :prcs, :class_name => 'Prc', :foreign_key => _(:id)

  validates_no_association_data :people, :campus_involvements, :groups, :ministry_campuses, :ministries, :dorms


  # This method will return the campus id associated with a given description
  def self.find_campus_id(description)
    find(:first, :conditions => {_(:desc) => description}).id
  end

  # This method will return the campus description associated with a given id
  def self.find_campus_description(id)
    find(:first, :conditions => {_(:id) => id}).desc
  end

  # This method will return the campus id associated with a given short_description
  def self.find_campus_id_from_short(short_description)
    find(:first, :conditions => {_(:short_desc) => short_description}).id
  end

  # This method will return an array of all campuses in Canada
  def self.find_campuses()
    find(:all, :joins => :region, :conditions => [ "#{__(:country_id, :region)} = ?", 1 ], :select => _(:desc), :order => _(:desc)).collect{ |c| [c.desc]}
  end

  # This method will return an array of all campuses associated to a given region_id
  def self.find_campuses_by_region(region_id)
    find(:all, :joins => :region, :conditions => {"#{_(:id, :region)}" => region_id}, :select => _(:short_desc), :order => _(:desc)).collect{ |c| [c.short_desc]}
  end


end
