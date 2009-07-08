require_model 'person'

class Person < ActiveRecord::Base
#  doesnt_implement_attributes :major => '', :minor => '', :url => '', :staff_notes => '', :updated_at => '', :updated_by => ''

  has_many :person_years, :foreign_key => _(:id, :year_in_school)
  has_many :year_in_schools, :through => :person_years
  has_many :cim_hrdb_admins, :class_name => 'CimHrdbAdmin'

  has_one :access
  has_many :users, :through => :access

  has_many :assignments, :include => :assignmentstatus
  has_many :assignmentstatuses, :through => :assignments

  has_one :emerg
  belongs_to :gender_, :class_name => "Gender", :foreign_key => :gender_id

  has_one :cim_hrdb_staff
  has_one :cim_hrdb_person_year

  has_one :person_extra_ref, :class_name => 'PersonExtra'

  def person_extra() 
    @person_extra ||= person_extra_ref || PersonExtra.new(:person_id => id)
  end
  def major() person_extra.major end 
  def major=(val) person_extra.major = val end 
  def minor() person_extra.minor end 
  def minor=(val) person_extra.minor = val end 
  def url() person_extra.major end 
  def url=(val) person_extra.url = val end 
  def staff_notes() person_extra.staff_notes end 
  def staff_notes=(val) person_extra.staff_notes = val end 
  def updated_at() person_extra.updated_at end 
  def updated_at=(val) person_extra.updated_at = val end 
  def updated_by() person_extra.updated_by end 
  def updated_by=(val) person_extra.updated_by = val end 
  def after_save
    person_extra.save!
  end

  def user
    users.first
  end

  def user=(val)
    throw "not implemented"
  end

  def year_in_school
    if year_in_schools.empty? then '' else year_in_schools.first.year_id end
  end

  def year_in_school=(val)
    throw "not implemented"
  end

  def get_emerg()
    return @emerg if @emerg
    @emerg = emerg
    return @emerg if @emerg
    # required fields are a bit of a pain
    @emerg = Emerg.create!(:emerg_birthdate => Time.now, :emerg_contact2Mobile => '', :emerg_contact2Rship => '', :emerg_contact2Home => '', :emerg_passportExpiry => Time.now, :emerg_contact2Work => '', :emerg_contact2Email => '', :emerg_contact2Name => '', :person_id => id)
    @emerg.emerg_passportExpiry = nil
    @emerg.save!
    return @emerg
  end
  def birth_date() get_emerg.emerg_birthdate; end
  def birth_date=(v) @save_emerg = true; emerg.emerg_birthdate = v if emerg; end
  def after_save
    if @save_emerg
      get_emerg.save!
      @save_emerg = false
    end
  end

  def created_by=(v) end # don't bother

  def gender() gender_ ? gender_.desc : '???' end

  def current_address() CimHrdbCurrentAddress.find(id) end
  def permanent_address() CimHrdbPermanentAddress.find(id) end

  def graduation_date() cim_hrdb_person_year.try(:grad_date) end

    # Attended and Unknown Status are not mapped
    ASSIGNMENTS_TO_ROLE = {
      'Current Student' => 'Student',
      'Alumni' => 'Alumni',
      'Staff' => 'Staff',
      'Staff Alumni' => 'Staff Alumni',
      'Campus Alumni' => 'Alumni'
    }

    def sync_cim_hrdb
      map_cim_hrdb_to_mt
    end

    def map_mt_to_cim_hrdb
      # TODO
    end

    # import information from the ciministry hrdb to the movement tracker database
    def map_cim_hrdb_to_mt
      c4c = Ministry.find_by_name 'Campus for Christ'

      # ciministry hrdb uses assignments to track
      # both ministry involvement and campus involvements.
      # Movement Tracker uses two individual tables.
      for a in assignments(:include => :assignmentstatus)
        campus = a.campus
        assignment = a.assignmentstatus.assignmentstatus_desc
        
        if campus && ASSIGNMENTS_TO_ROLE[assignment]
        
          # ministry involvement
          role = MinistryRole.find_by_name ASSIGNMENTS_TO_ROLE[assignment]
          
          # if they have a staff role
          if (assignment == 'Staff' ? !cim_hrdb_staff.nil? : true) # verify staff
            mi_atts = {
              :ministry_role_id => role.id,
              :ministry_id => c4c.id, 
              :person_id => self.id }
              
            # make sure they are involved in the ministry
            mi = MinistryInvolvement.find :first, :conditions => mi_atts
            mi ||= ministry_involvements.create!(mi_atts)

            # FIXME is this a bug?
            mi.admin = cim_hrdb_admins.count > 0

            mi.save!
          end
        
          # add the appropriate campus involvements
          ci = campus_involvements.find_or_create_by_campus_id campus.id
          school_year = cim_hrdb_person_year.try(:school_year)
          grad_date = cim_hrdb_person_year.try(:grad_date)
          ci.ministry_id = c4c.id
          ci.campus_id = campus.id
          ci.graduation_date = grad_date
          ci.school_year = school_year
          ci.save!
        end
      end
      true
    end

    MockAggregation = Struct.new(:klass)
    def self.reflect_on_aggregation(name)
      if [:birth_date].include? name
        agg = MockAggregation.new
        agg.klass = Date
        return agg
      end
      super
    end

    def self.create_new_cim_hrdb_account(guid, fn, ln, uid)
      # first and last names can't be nil
      fn ||= ''
      ln ||= ''

      v = User.new
      v.guid = guid
      v.language_id = 1
      v.viewer_isActive = true
      v.accountgroup_id = 15
      v.viewer_lastLogin = 0
      v.viewer_userID = uid
      v.save!
      #v.viewer_lastLogin = nil # hack to get by the create restriction

      p = Person.create! :person_fname => fn, :person_lname => ln,
        :person_legal_fname => '', :person_legal_lname => '',
        :birth_date => nil
      ag_st = AccountadminAccessgroup.find_by_accessgroup_key '[accessgroup_student]'
      ag_all = AccountadminAccessgroup.find_by_accessgroup_key '[accessgroup_key1]'
      AccountadminVieweraccessgroup.create! :viewer_id => v.id, :accessgroup_id => ag_st.id
      AccountadminVieweraccessgroup.create! :viewer_id => v.id, :accessgroup_id => ag_all.id
      Access.create :viewer_id => v.id, :person_id => p.id

      v
    end
end