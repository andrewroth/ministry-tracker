class CampusInvolvement < ActiveRecord::Base
  load_mappings
  validates_presence_of :campus_id, :person_id, :ministry_id, :school_year_id

  def validate
    if !archived?
      if (ci = CampusInvolvement.find(:first, :conditions => { :person_id => person_id, :campus_id => campus_id, :end_date => nil })) && (ci != self)
        errors.add_to_base "There is already a campus involvement for the campus \"#{campus.name}\"; you can only be involved once per campus.  Archive the existing involvement and try again."
      end
    end
  end

  belongs_to :school_year
  belongs_to :campus
  belongs_to :person
  belongs_to :ministry
  belongs_to :added_by, :class_name => "Person", :foreign_key => _(:added_by_id)
  has_many :student_involvement_histories

  def archived?() end_date.present? end

  def new_student_history
    StudentInvolvementHistory.new :person_id => person_id, :campus_id => campus_id, :school_year_id => school_year_id, :end_date => Date.today, :ministry_role_id => find_or_create_ministry_involvement.ministry_role_id, :start_date => (student_involvement_histories.last.try(:end_date) || start_date), :campus_involvement_id => id
  end

  def derive_ministry
    ministry_campus = MinistryCampus.find :first, :conditions => { :campus_id => campus_id }
    ministry_campus.try(:ministry)
  end

  def find_or_create_ministry_involvement
    ministry = derive_ministry || Cmt::CONFIG[:default_ministry] || Ministry.first
    mi = ministry.ministry_involvements.find :first, :conditions => [ "person_id = ? AND end_date IS NULL", person_id ]
    if mi.nil?
      sr = StudentRole.find_by_name 'Student'
      sr ||= StudentRole.find :last, :order => "position"
      mi = ministry.ministry_involvements.create :person => person, :ministry_role => sr
    elsif mi.ministry_role_id.nil?
      mi.ministry_role_id = StudentRole
      mi.save
    end
    mi
  end
end
