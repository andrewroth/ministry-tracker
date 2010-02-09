require_model 'person'

class Person < ActiveRecord::Base
  unloadable

  CIM_MALE_GENDER_ID = 1
  CIM_FEMALE_GENDER_ID = 2
  US_MALE_GENDER_ID = 1
  US_FEMALE_GENDER_ID = 0

  MAX_SEARCH_RESULTS = 100

#  doesnt_implement_attributes :major => '', :minor => '', :url => '', :staff_notes => '', :updated_at => '', :updated_by => ''

  has_many :cim_hrdb_admins, :class_name => 'CimHrdbAdmin'

  has_one :access
  has_many :users, :through => :access

  has_many :assignments, :include => :assignmentstatus
  has_many :assignmentstatuses, :through => :assignments

  has_one :emerg
  belongs_to :gender_, :class_name => "Gender", :foreign_key => :gender_id

  has_one :cim_hrdb_staff
  has_many :cim_hrdb_person_years
  has_many :cim_hrdb_school_years, :through => :cim_hrdb_person_years, :source => :school_year

  has_one :person_extra_ref, :class_name => 'PersonExtra'

  belongs_to :title, :foreign_key => :title_id

  belongs_to :state, :foreign_key => :province_id

  belongs_to :country, :foreign_key => :country_id

  def created_at=(v) end # noop since it would have set the id to the timestamp

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
  
  def first_name=(val="")
    self.person_legal_fname ||= ""
    self.person_fname = val
  end
  
  def last_name=(val="")
    self.person_legal_lname ||= ""
    self.person_lname = val
  end

  def user
    users.first
  end

  def user=(val)
    throw "not implemented"
  end

  def get_emerg()
    return @emerg if @emerg
    @emerg = emerg
    return @emerg if @emerg
    unless self.new_record?
      # required fields are a bit of a pain
      @emerg = Emerg.create!(:emerg_birthdate => Time.now, :emerg_contact2Mobile => '', :emerg_contact2Rship => '', :emerg_contact2Home => '', :emerg_passportExpiry => Time.now, :emerg_contact2Work => '', :emerg_contact2Email => '', :emerg_contact2Name => '', :person_id => id)
      @emerg.emerg_passportExpiry = nil
      @emerg.emerg_birthdate = nil
      @emerg.save!
    end
    return @emerg
  end
  def birth_date() get_emerg ? get_emerg.emerg_birthdate : nil; end
  def birth_date=(v) @save_emerg = true; emerg.emerg_birthdate = v if emerg; end
  def after_save
    if @save_emerg
      get_emerg.save!
      @save_emerg = false
    end
  end

  def created_by=(v) end # don't bother

  def gender()
    case gender_id 
    when CIM_MALE_GENDER_ID
      US_MALE_GENDER_ID
    when CIM_FEMALE_GENDER_ID
      US_FEMALE_GENDER_ID
    else
      nil
    end
  end

  def gender=(val)
    case val
    when US_MALE_GENDER_ID.to_i, US_MALE_GENDER_ID.to_s, 'M'
      self.gender_id = CIM_MALE_GENDER_ID
    when US_FEMALE_GENDER_ID.to_i, US_FEMALE_GENDER_ID.to_s, 'F'
      self.gender_id = CIM_FEMALE_GENDER_ID
    end
  end

  def current_address() id ? CimHrdbCurrentAddress.find(id) : CimHrdbCurrentAddress.new  end
  def permanent_address() id ? CimHrdbPermanentAddress.find(id) : CimHrdbPermanentAddress.new end

  def graduation_date() cim_hrdb_person_year.try(:grad_date) end

    # Attended and Unknown Status are not mapped
    ASSIGNMENTS_TO_ROLE = ActiveSupport::OrderedHash.new
    ASSIGNMENTS_TO_ROLE['Alumni'] = 'Alumni' # not sure why we have two Campus Alumni like roles..
    ASSIGNMENTS_TO_ROLE['Campus Alumni'] = 'Alumni'
    ASSIGNMENTS_TO_ROLE['Staff Alumni'] = 'Staff Alumni'
    ASSIGNMENTS_TO_ROLE['Current Student'] = 'Student'
    ASSIGNMENTS_TO_ROLE['Staff'] = 'Staff'

    def sync_cim_hrdb
      map_cim_hrdb_to_mt
    end

    def map_mt_to_cim_hrdb
      # TODO
    end

    # ministry and role contain what the new ministry_involvement should be set up
    # for those attributes
    def upgrade_ministry_involvement(ministry, role)
      atts = {
        :ministry_role_id => role.id,
        :ministry_id => ministry.id,
        :person_id => self.id,
        :admin => self.cim_hrdb_admins.count > 0,
        :end_date => nil
      }

      # find highest ministry involvement
      mi = self.ministry_involvements.find(:first, :conditions => ["#{MinistryInvolvement.table_name + '.' + _(:ministry_id, :ministry_involvement)} IN (?)", ministry.id], :joins => :ministry_role, :order => _(:position, :ministry_role))

      if mi.nil?
        mi = ministry_involvements.create!(atts)
      else
        # don't demote them (higher roles have lower position values)
        if (mi.ministry_role.class == StaffRole && role.class == StudentRole) || 
             (mi.ministry_role && mi.ministry_role.position < role.position)
          atts.delete :ministry_role_id
        end

        mi.update_attributes atts
      end
    end

    def get_highest_assignment
      return nil if assignments.empty?

      best_p = nil

      for a in assignments
        a_p = ASSIGNMENTS_TO_ROLE.keys.index(a.assignmentstatus.assignmentstatus_desc)
        if (a_p && !best_p) || (a_p && a_p > best_p)
          best_p = a_p
          best_a = a
        end
      end

      best_a
    end

    def map_cim_hrdb_to_mt(options = {})
      c4c = Ministry.find_by_name 'Campus for Christ'

      # assume if they already have involvements they're properly set up on the pulse
      return if ministry_involvements.present? || campus_involvements.present?

      # staff *must* have a cim_hrdb_staff entry
      if cim_hrdb_staff && cim_hrdb_staff.is_active == 1
        # look for a Staff assignment to determine campus
        staff_assign = Assignmentstatus.find_by_assignmentstatus_desc("Staff")
        campus = assignments.find_by_assignmentstatus_id(staff_assign).try(:campus)

        if campus
          mc = MinistryCampus.find(:last, :conditions => { :campus_id => campus.id })
          ministry = mc.try(:ministry)
          
          if ministry
            # finally, they have everything needed to be marked staff on the pulse
            staff_role = StaffRole.find_by_name('Staff')
            c4c_mi = ministry_involvements.find_or_create_by_ministry_id(c4c.id)
            c4c_mi.ministry_role_id = staff_role.id
            c4c_mi.start_date = Date.today
            c4c_mi.end_date = nil
            c4c_mi.save!

            # add staff team role
            unless ministry == c4c
              staff_team_role = StaffRole.find_by_name('Staff Team')
              team_mi = ministry_involvements.find_or_create_by_ministry_id(ministry.id)
              team_mi.ministry_role_id = staff_team_role.id
              team_mi.start_date = Date.today
              team_mi.end_date = nil
              team_mi.save!
            end
          end
        end
      end
    end

    # import information from the ciministry hrdb to the movement tracker database
    #
    # when secure flag is on, it will import staff with a cim_hrdb_assignment (as staff)
    # only if they cim_hrdb_staff entry
    #
    def map_cim_hrdb_to_mt_old(options = {})
      options = { :secure => true
      }.merge(options)

      c4c = Ministry.find_by_name 'Campus for Christ'
      
      if !self.email.present?
        self.email = self.user.viewer_userID if self.user
        self.save
      end
      
      # ciministry hrdb uses assignments to track
      # both ministry involvement and campus involvements.
      # Movement Tracker uses two individual tables.
      a = get_highest_assignment
      return unless a

      campus = a.campus
      assignment = a.assignmentstatus.assignmentstatus_desc

      if campus && ASSIGNMENTS_TO_ROLE[assignment]

        # ministry involvement
        role = MinistryRole.find_by_name ASSIGNMENTS_TO_ROLE[assignment]

        # if they have a staff role (verify staff if secure flag is on)
        if (assignment == 'Staff' && options[:secure] ? !cim_hrdb_staff.nil? : true)
          staff = true

          # staff should get a staff team role on the ministry and a staff role in c4c
          mc = MinistryCampus.find_all_by_campus_id(campus).last
          if mc && mc.ministry
            upgrade_ministry_involvement(mc.ministry, MinistryRole.find_by_name('Staff Team'))
          end
          # they should also get a generic staff involvement
          upgrade_ministry_involvement(c4c, MinistryRole.find_by_name('Staff'))
        else
          staff = false
        end

        # add the appropriate campus involvements
        # not sure why, but it seems that the association breaks the person array
        # in the rake canada:import task.  It was making the person_id be 1, really
        # weird
        #ci = campus_involvements.find_or_create_by_campus_id campus.id
        ci = CampusInvolvement.find :first, :conditions => { 
          :person_id => self.id,
          :campus_id => campus.id
        }
        ci ||= CampusInvolvement.new :person_id => self.id, :campus_id => campus.id

        school_year = cim_hrdb_person_year.try(:school_year)
        ci.ministry_id = c4c.id
        ci.campus_id = campus.id
        ci.graduation_date = graduation_date
        if staff
          ci.school_year = SchoolYear.find_by_year_desc "Alumni"
        else
          ci.school_year = school_year
        end
        ci.end_date = nil
        #begin
        ci.save!
        #rescue
        #  puts "self: #{self.inspect} ci: #{ci.inspect}"
        #end
      end
      true

      # add a staff ministry role if they're cim_hrdb_staff
      if !cim_hrdb_staff.nil?
        upgrade_ministry_involvement(c4c, MinistryRole.find_by_name('Staff'))
      end
    end

    # TODO: Can this be removed now?
    MockAggregation = Struct.new(:klass)
    def self.reflect_on_aggregation(name)
      if [:birth_date].include? name
        agg = MockAggregation.new
        agg.klass = Date
        return agg
      end
      super
    end

    def self.create_viewer(guid, uid)
      v = User.new
      v.guid = guid
      v.language_id = 1
      v.viewer_isActive = true
      v.accountgroup_id = 15
      v.viewer_lastLogin = 0
      v.viewer_userID = uid
      v.save!
      #v.viewer_lastLogin = nil # hack to get by the create restriction

      v
    end

    def self.create_new_cim_hrdb_account(guid, fn, ln, uid)
      # first and last names can't be nil
      fn ||= ''
      ln ||= ''
      p = Person.create! :person_fname => fn, :person_lname => ln,
        :person_legal_fname => '', :person_legal_lname => '',
        :birth_date => nil, :person_email => uid
      v = Person.create_viewer(guid, uid)       
      p.create_access(v)

      v
    end

    def create_user_and_access_only(guid, uid)
      v = Person.create_viewer(guid, uid)
      self.create_access(v)
    end

    def create_access(v)
      #ag_st = AccountadminAccessgroup.find_by_accessgroup_key '[accessgroup_student]' #this returns nil currently. This is where we get an error
      ag_all = AccountadminAccessgroup.find_by_accessgroup_key '[accessgroup_key1]'
      #AccountadminVieweraccessgroup.create! :viewer_id => v.id, :accessgroup_id => ag_st.id
      AccountadminVieweraccessgroup.create! :viewer_id => v.id, :accessgroup_id => ag_all.id
      Access.create :viewer_id => v.id, :person_id => self.id
    end

    def self.find_user(person, address)
      # is there a user with the same email?
      user = User.find(:first, :conditions => ["#{_(:username, :user)} = ?", address.email])
      if user && user.person.nil?
        # If we have an orphaned user record, might as well use it...
        person.email = address.email
        person.save(false)
        person.create_access(user)
        p = person
      else
        p = user.person if user
      end
      unless p
        p = Person.find(:first, :conditions => {:person_email => address.email})
        p.create_user_and_access_only("", p.person_email) if p
      end
      return p
    end

    def full_destroy
      self.user.try(:destroy)
      self.access.try(:destroy)
      self.emerg.try(:destroy)
      self.cim_hrdb_person_year.try(:destroy)
      self.destroy
    end

    def self.search(search, page, per_page)
      if search then
        Person.paginate(:page => page,
                        :per_page => per_page,
                        :conditions => ["concat(#{_(:first_name, :person)}, \" \", #{_(:last_name, :person)}) like ? " +
                                        "or #{_(:id, :person)} like ? ",
                                        "%#{search}%", "%#{search}%"])
      else
        nil
      end
    end

    # This method will return the person associated with a given id
    def self.find_person(person_id)
      find(:first, :conditions => {_(:id) => person_id})
    end
end
