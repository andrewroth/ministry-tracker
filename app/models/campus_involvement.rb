class CampusInvolvement < ActiveRecord::Base
  load_mappings
  validates_presence_of :campus_id, :person_id, :ministry_id, :school_year_id

  def validate
    if !archived?
      if CampusInvolvement.find(:first, :conditions => { :person_id => person_id, :campus_id => campus_id })
        errors.add_to_base "There is already a campus involvement for the campus \"#{campus.name}\"; you can only be involved once per campus.  Archive the existing involvement and try again."
      end
    end
  end

  belongs_to :school_year
  belongs_to :campus
  belongs_to :person
  belongs_to :ministry
  belongs_to :added_by, :class_name => "Person", :foreign_key => _(:added_by_id)

  def archived?() end_date.present? end
end
