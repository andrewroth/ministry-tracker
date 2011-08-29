require 'csv'
require 'yaml'

namespace :cmt do
  namespace :views do
    desc "rebuilds all views in the CMT"
    task :rebuild => :environment do
      rebuilt = View.all.each { |v| v.build_query_parts! }
      puts "Rebuilt #{rebuilt.length} views"
    end
  end

  desc "refresh data into the cim_stats_monthlyreport table from the data into cim_stats_semesterreport table" 
  task :update_monthly_report => :environment do
    hsh_month_for_semester ||= Hash.new

    SemesterReport.all.each do | sr |
      #Find the right month_id for the current semester record
      if !(hsh_month_for_semester.has_key?(sr[:semester_id]))
        hsh_month_for_semester[sr[:semester_id]] = Month.find(:all, :conditions => { :semester_id => sr[:semester_id] }, :order => :month_number).last.id
      end      
      month_id = hsh_month_for_semester[sr[:semester_id]]

      #try to find a record for the current month_id, campus_id
      monthly_report = MonthlyReport.find(:first, :conditions => { :month_id => month_id, :campus_id => sr[:campus_id] })
      #if no record, create a new one
      monthly_report ||= MonthlyReport.new
      monthly_report.campus_id = sr[:campus_id]
      monthly_report.month_id = month_id
      
      #update the data
      monthly_report[:monthlyreport_avgPrayer] = sr[:semesterreport_avgPrayer] if monthly_report[:monthlyreport_avgPrayer] == 0
      monthly_report[:monthlyreport_numFrosh] = sr[:semesterreport_numFrosh] if monthly_report[:monthlyreport_numFrosh] == 0
      monthly_report[:monthlyreport_totalStudentInDG] = sr[:semesterreport_numInStaffDG] + sr[:semesterreport_numInStudentDG] if monthly_report[:monthlyreport_totalStudentInDG] == 0
      monthly_report[:monthlyreport_totalSpMult] = sr[:semesterreport_numSpMultStaffDG] + sr[:semesterreport_numSpMultStdDG] if monthly_report[:monthlyreport_totalSpMult] == 0
      
      monthly_report.save!
    end
    

  end

  desc "add a year, and appropriate semesters, months and weeks to cim_stats tables"
  task :add_years_to_cim_stats => :environment do

    puts "\nType a number to add that many years, and the appropriate semesters, months and weeks to the cim_stats tables. Type '0' to cancel."
    response = STDIN.gets
    num_years_to_add = response.to_i

    num_years_to_add.times do

      # add year first
      last_year = Year.last
      last_year = last_year.description[-4..-1].to_i
      new_year = Year.new
      new_year.description = "#{last_year} - #{last_year+1}"
      puts "Adding year #{new_year.description}"
      new_year.save


      # for each year, if there are not 3 semesters, add them
      Year.all.each do |year|
        unless year.semesters.size == 3

          # create fall semester
          unless year.semesters.all(:conditions => {:semester_desc => "Fall #{year.description[0..3]}"}).any?

            new_semester = year.semesters.build(:semester_desc => "Fall #{year.description[0..3]}",
                                                :start_date => "#{year.description[0..3]}-09-01")
            puts "Adding semester #{new_semester.description}"
            new_semester.save
          end

          # create winter semester
          unless year.semesters.all(:conditions => {:semester_desc => "Winter #{year.description[-4..-1]}"}).any?

            new_semester = year.semesters.build(:semester_desc => "Winter #{year.description[-4..-1]}",
                                                :start_date => "#{year.description[-4..-1]}-01-01")
            puts "Adding semester #{new_semester.description}"
            new_semester.save
          end

          # create summer semester
          unless year.semesters.all(:conditions => {:semester_desc => "Summer #{year.description[-4..-1]}"}).any?

            new_semester = year.semesters.build(:semester_desc => "Summer #{year.description[-4..-1]}",
                                                :start_date => "#{year.description[-4..-1]}-05-01")
            puts "Adding semester #{new_semester.description}"
            new_semester.save
          end

        end
      end


      # for each year, if there are not 12 months, add them
      Year.all.each do |year|
        unless year.months.size == 12

          if year.months.any?
            last_month_number = year.months.last.month_number
            month_counter = last_month_number == 12 ? 1 : last_month_number + 1
          else
            month_counter = 9 # month 9, September, is the first month of a year
          end

          while year.months.size < 12 do
            new_month = year.months.build(:month_number => month_counter)

            new_month.calendar_year = month_counter > 8 ? year.description[0..3] : year.description[-4..-1]

            new_month.description = "#{Date::MONTHNAMES[month_counter]} #{new_month.calendar_year}"

            new_month.semester_id = Semester.find_semester_from_date("#{new_month.calendar_year}-#{month_counter}-1").id

            puts "Adding month #{new_month.description}"
            new_month.save

            month_counter = month_counter == 12 ? 1 : month_counter + 1
          end

        end
      end


      # go to last week and, stopping after the last month, add enough weeks

      last_week = Week.last
      week_counter_date = Date.parse(last_week.end_date.to_s)
      raise "The last week in your database has an unexpected date (it is not a Saturday)" if week_counter_date.wday != 6
      week_counter_date += 7

      last_month = Month.last
      last_month_date = Date.parse("#{last_month.description[-4..-1]}-#{last_month.month_number}-4") # if day is <= 3 it belongs to previous month
      last_month_date = last_month_date >> 1 # get date of first day of next month

      while week_counter_date < last_month_date do
        new_week = Week.new
        new_week.end_date = week_counter_date

        # set semester_id
        new_week.semester_id = Semester.find_semester_from_date(new_week.end_date, true).id

        # set month_id
        new_week.month_id = Month.find_month_from_date(new_week.end_date, true).id

        puts "Adding week #{new_week.end_date}"
        new_week.save

        week_counter_date += 7
      end
      
    end
  end


  desc "change cim_stats_prc semester_id to match their date"
  task :update_prc_semesters_to_match_date => :environment do

    puts "\nType 'yes' to find records in '#{Prc.table_name}' that have a date which does not match the semester given by their semester_id and then change the semester_id to match the date, leaving the date unchanged."
    response = STDIN.gets
    if response.to_s.upcase == "YES\n"

      puts "Searching through '#{Prc.table_name}'..."

      count = 0
      
      Prc.all.each do |prc|
        proper_semester = ::Semester.find_semester_from_date(prc.date)
        unless prc.semester_id == proper_semester.id
          count += 1
          prc.semester_id = proper_semester.id
          prc.save
        end
      end

      puts "Corrected #{count} records."

    else
      puts "Cancelled the task, no records modified."
      exit
    end
  end


  desc "add c4c staff ministry involvement to all active staff in cim_hrdb_staff"
  task :add_missing_staff_ministry_involvements => :environment do
    c4c = Ministry.find_by_name 'Campus for Christ'
    people_with_staff_involvements = MinistryInvolvement.all(:joins => [:ministry_role, :person],
                                                             :select => "DISTINCT #{Person.table_name}.person_id",
                                                             :conditions => ["#{MinistryRole.table_name}.type = ? AND #{MinistryInvolvement.table_name}.ministry_id = ? AND #{MinistryInvolvement.table_name}.end_date IS NULL", "StaffRole", c4c.id])

    staff_needing_involvements = CimHrdbStaff.all(:conditions => ["#{CimHrdbStaff.table_name}.is_active = 1 AND #{CimHrdbStaff.table_name}.person_id NOT IN (?)", people_with_staff_involvements.map { |p| p.person_id } ])

    if staff_needing_involvements.size == 0
      puts "Found no staff with missing staff involvements."
      exit
    end

    puts "\nThe following " + staff_needing_involvements.size.to_s + " people, who are active staff in cim_hrdb_staff, were found to not have a Campus for Christ staff ministry involvement:\n\n"
    staff_needing_involvements.each do |staff|
      puts staff.person_id.to_s + " " + staff.person.person_fname.to_s + " " + staff.person.person_lname.to_s
    end

    puts "\nType 'yes' to add a Campus for Christ staff ministry involvement the these people, type 'no' to cancel."
    response = STDIN.gets
    if response.to_s.upcase == "YES\n"
      puts "Adding missing staff involvements..."

      staff_needing_involvements.each do |staff|
        staff.person.map_cim_hrdb_to_mt
      end

      puts "Done."
    else
      puts "Cancelled the task, no records modified."
      exit
    end
  end


  desc "remove staff ministry involvement from students that aren't staff"
  task :remove_staff_involvement_from_students => :environment do
    puts "\nType 'yes' to check the cim_hrdb_staff table for people who are legitimately staff, otherwise type 'no' (you probably want to type 'yes')."
    response = STDIN.gets

    if response.to_s.upcase == "NO\n"
      # find all people that have a ministry involvement of type StudentRole
      students = Person.all(:joins => {:ministry_involvements => :ministry_role},
                            :conditions => [ "#{MinistryRole.table_name}.type = ? AND #{MinistryInvolvement.table_name}.end_date IS NULL", "StudentRole" ])

      msg = " people have student ministry involvements AND staff ministry involvements:\n\n"

    else
      # find all people that have a ministry involvement of type StudentRole and are EITHER not present in the cim_hrdb_staff table OR are present in cim_hrdb_staff table but is_active = 0
      students = Person.all(:include => {:cim_hrdb_staff => [], :ministry_involvements => :ministry_role},
                            :conditions => [ "(#{CimHrdbStaff.table_name}.staff_id IS NULL OR #{CimHrdbStaff.table_name}.is_active = 0) AND #{MinistryRole.table_name}.type = ? AND #{MinistryInvolvement.table_name}.end_date IS NULL", "StudentRole" ])
                          
      msg = " people have student ministry involvements AND staff ministry involvements AND are EITHER not in the cim_hrdb_staff table OR are in the cim_hrdb_staff table but is_active is false:\n\n"
    end

    # of the students previously found, find those that have a ministry involvement of type StaffRole
    involvements_to_remove = MinistryInvolvement.all(:joins => [:person, :ministry_role],
                                                     :select => "#{Person.table_name}.person_id, #{Person.table_name}.person_fname, #{Person.table_name}.person_lname, #{MinistryInvolvement.table_name}.id AS ministry_involvement_id",
                                                     :conditions => [ "#{MinistryRole.table_name}.type = ? AND #{MinistryInvolvement.table_name}.end_date IS NULL AND #{Person.table_name}.person_id IN (?)", "StaffRole", students.map { |p| p.person_id } ])

    if involvements_to_remove.size == 0
      puts "Found no students with staff involvements."
      exit
    end

    puts "\nThe following " + involvements_to_remove.size.to_s + msg
    involvements_to_remove.each do |involvement|
      puts involvement.person_id.to_s + " " + involvement.person_fname.to_s + " " + involvement.person_lname.to_s
    end

    puts "\nType 'yes' to remove these people's staff ministry involvements, type 'no' to cancel."
    response = STDIN.gets
    if response.to_s.upcase == "YES\n"
      puts "Removing staff involvements..."

      involvements_to_remove.each do |involvement|
        MinistryInvolvement.find(involvement.ministry_involvement_id).destroy
      end

      puts "Done."
    else
      puts "Cancelled the task, no records modified."
      exit
    end
  end

end

namespace :db do
  desc "db:reset and db:seed"
  task :rebuild => [ "db:reset", "db:seed" ]
  
  task :seed_test_users => :environment do
    abort("test users shouldn't be used in production environment") if Rails.env == "production"
    
    test_users = YAML.load_file("config/test_users.yml")
    
    test_users.each do |key,hash|
      user = User.find_or_create_from_guid_or_email(hash["guid"], hash["email"], hash["first_name"], hash["last_name"])
      
      person = user.person
      
      person.all_campus_involvements.destroy_all
      person.all_ministry_involvements.destroy_all
      
      ministry = Ministry.find(hash["ministry_id"])
      campus = ministry.campuses.first
      ministry_role = MinistryRole.find(:first, :conditions => {:name => hash["role"]})
      school_year = SchoolYear.find(:first, :conditions => ["#{SchoolYear._(:name)} = ?", hash["school_year"]])
      
      person.add_or_update_campus(campus.id, school_year.id, ministry.id, "MT")
      person.add_or_update_ministry(ministry.id, ministry_role.id)
    end
  end
  
  task :rebuild_with_utf8, :database do |t, args|
    
    # make sure we're properly setup to use utf8 character set
    %w(character_set_database character_set_client character_set_connection).each do |v|
      ActiveRecord::Base.connection.execute("SHOW VARIABLES LIKE '#{v}'").each do |f|
        unless f[1] == "utf8"
          puts "ERROR: MySQL database isn't properly encoded! Detected '#{f[1]}' when it shound be 'utf8'."
          puts "Kindly set your #{f[0]} variable to 'utf8'. You can do this by adding 'encoding: utf8' to your database.yml"
          RAILS_DEFAULT_LOGGER.error("MySQL database isn't properly encoded!")
          exit 1
        end
      end
    end
    
    database = args[:database]
    abort("\nYou must pass the database name as an argument e.g. rake db:rebuild_with_utf8['database_name']") unless database
    
    config   = Rails::Configuration.new
    host     = config.database_configuration[Rails.env]["host"]
    username = config.database_configuration[Rails.env]["username"]
    password = config.database_configuration[Rails.env]["password"]
    host ||= root_config[:host]
    username ||= root_config[:username]
    password ||= root_config[:password]
    abort("\nFailed to get database config info from your Rails config, you may need to create a config/database_root.yml") unless host.present? && username.present? && password.present?

    puts "\n\nWARNING: You should configure your MySQL to use UTF-8 by default in your my.cnf file.\n"
    puts "\nThe following database is about to be destroyed and recreated using UTF-8 (a backup dump will be created in tmp/): #{database}\n"
    puts "\nPress enter to continue otherwise Ctrl-c to cancel...\n"
    response = STDIN.gets
    abort("") unless response.to_s.upcase == "\n"
    
    dump_filename = "tmp/dump_#{Time.now.to_i}.sql"
    backup_dump_filename = "tmp/#{database}_dump_#{Time.now.to_i}.sql"
    sed_filename = "tmp/dump_sed_#{Time.now.to_i}.sql"
    
    puts "# dumping the database"
    execute_shell "mysqldump --host=#{host} --user=#{username} --password=#{password} --skip-set-charset #{database} > #{dump_filename}"
    
    puts "\n# copying database dump to backup file #{backup_dump_filename}"
    execute_shell "cp #{dump_filename} #{backup_dump_filename}"
    
    puts "\n# converting the character set and collation from latin1 to utf8 in the dump"
    execute_shell "sed -e 's/CHARSET=latin1/CHARSET=utf8/g' -e 's/latin1_general_ci/utf8_general_ci/g' -e 's/CHARACTER SET latin1/CHARACTER SET utf8/g' <#{dump_filename} > #{sed_filename}"
    
    puts "\n# destroying and recreating the database"
    execute_shell "mysql --host=#{host} --user=#{username} --password=#{password} --execute='DROP DATABASE #{database}; CREATE DATABASE #{database} CHARACTER SET utf8 COLLATE utf8_general_ci;'"
    
    puts "\n# rebuilding database with the dump"
    execute_shell "mysql --host=#{host} --user=#{username} --password=#{password} --default-character-set=utf8 #{database} < #{sed_filename}"
    
    puts "\n# deleting tmp files"
    execute_shell "rm #{dump_filename}"
    execute_shell "rm #{sed_filename}"
    
    puts "\n# finished"
  end
  
  task :import_training_course_data_from_csv => :environment do
    
    @parsed_file = CSV::Reader.parse(File.open('tmp/c4c_staff_training_record.csv', 'rb'), ',')
    courses = []
    person_count = 0
    
    @parsed_file.each_with_index  do |row, i|
      if i == 0 # header row
        courses = row
        courses.delete_at(0)
        
        # add a training course for each header
        courses.each_with_index do |course, j|
          tc = TrainingCourse.new({:name => course})
          tc.save!
          courses[j] = tc
        end
      else
        
        person = Person.find(row[0].to_i)
        if person
          person_count = person_count+1
          row.delete_at(0)
          row.each_with_index do |col, j|
            finished = (col == "TRUE" || col == "100%")
            percent_complete = col && col.include?("%") ? col : nil
            if finished || percent_complete
              ptc = PersonTrainingCourse.new(:person_id => person.id, :training_course_id => courses[j].id, :finished => finished, :percent_complete => percent_complete)
              ptc.save!
            end
          end
        end
      end
    end
    puts "Imported training data for #{person_count} people"
  end
  
end

task :people => :environment do
  File.open('lib/tasks/people.csv') do |f|
    f.gets
    f.each_line do |line|
      line.chomp!
      array = line.split(';').map {|s| s.slice!(1..-2)}
      array[17] = 'Male' if array[17] == 'M'
      array[17] = 'Female' if array[17] == 'F'
      person = Person.create(:first_name => array[3],
                             :last_name => array[4],
                             :gender => array[17],
                             :old_id => array[0])
      if person
        user = User.create!(:username => array[1],
                            :password => array[2],
                            :person_id => person.id)
              
        current = CurrentAddress.create!(:email => array[5],
                                        :address1 => array[6],
                                        :city => array[7],
                                        :state => array[8],
                                        :zip => array[9],
                                        :phone => array[10],
                                        :alternate_phone => array[11],
                                        :person_id => person.id)
                                      
        perm = PermanentAddress.create!(:address1 => array[12],
                                        :city => array[13],
                                        :state => array[14],
                                        :zip => array[15],
                                        :phone => array[16],
                                        :person_id => person.id)
      end                                    
    end
  end
end

task :ucla => :environment do
  CSV.open('lib/tasks/import.csv', 'w') do |writer|
    writer << %w{first_name last_name year_in_school level_of_school email phone alternate_phone address1 city state zip country gender}
    CSV.open('lib/tasks/ucla.csv', 'r') do |row|
      year = case row[3].to_s
             when '1'
               'Freshman'
             when '2'
               'Sophomore'
              when '3'
                'Junior'
              when '4'
                'Senior'
              when 'Grad'
                '1st Year'
              end
      level = case row[3].to_s
              when '1','2','3','4'
                'Undergrad'
              when 'Grad'
                'Grad Schol'
              when 'Staff'
                next
              end
      address = row[7].to_s.split('<br>')
      address = [address[0]] + address[1].split(', ') if address.length > 1
      address = address[0..1] + address[2].split(' ') if address.length > 2
      city = row[8].present? ? row[8] : address[1]
      state = row[9].present? ? row[9] : address[2]
      zip = row[10].present? ? row[10] : address[3]
      writer << [row[1], row[2], year, level, row[4], row[5], row[6], address[0], city, state, zip, 'USA', row[11].to_s == 'F' ? 'Female' : 'Male']
    end
  end
end
task :attributes => :environment do
  campuses = %w{0 33251 32921 32934 32812 32925 33254 37151 37151 39523}
  File.open('lib/tasks/attributes.csv') do |f|
    f.each_line(/\r\n/) do |line|
      line = line.chomp!
      array = line.split(';').map {|s| s.slice!(1..-2)}
      next unless array[1] == 'campus' && array[0].to_s != '0'
      person = Person.find_by_old_id(array[0].to_i)
      if person
        campus_id = campuses[array[2].to_i].to_i
        ci = CampusInvolvement.create(:person_id => person.id, :campus_id => campus_id)
        puts ci.inspect
      end
    end
  end
end
task :schools => :environment do
  Campus.delete_all
  File.open('lib/tasks/schools.csv') do |f|
    # header = f.gets
    # Campus.transaction do 
      f.each_line do |line|
        line.chomp!
        array = line.slice(1..-2).split('","').map {|s| s.strip }
        array[3] = array[3].titleize if array[3]
        array[4] = array[4].titleize if array[4]
        array[5] = array[5].titleize if array[5]
        array[6] = array[6].titleize if array[6]
        array[10] = array[10].titleize if array[10]
        # puts array.inspect
        type = array[17] == 'High School' ? 'HighSchool' : 'College'
        puts array[0]+': '+type
        # puts array.inspect if type == 'College'
        sql = "INSERT INTO campuses(id, name, address, address2, type, city, state, zip, county, country, phone, url, abbrv, "+
                                   "is_secure, enrollment, created_at, updated_at)" +
              "VALUES (#{array[0]},'#{escape_string(array[3])}','#{escape_string(array[4])}','#{escape_string(array[5])}',"+
                     "'#{type}','#{escape_string(array[6])}','#{array[7] ? array[7].upcase : nil}',"+
                     "'#{escape_string(array[8])}','#{escape_string(array[10])}','#{array[9].to_s.empty? ? 'USA' : escape_string(array[9])}','#{escape_string(array[79])}',"+
                     "'#{escape_string(array[11].downcase) if array[11]}','#{array[99]}','#{array[103]}',#{array[95].to_i}, NOW(), NOW())"
        # begin
          Campus.connection.insert(sql) unless array[0].to_i == 0 #|| array[17] == 'High School'
        # rescue; end
      end
    # end
  end
end
task :niu => :environment do
  ministry = Ministry.find(:first, :conditions =>"name = 'NIU'")
  File.open('lib/tasks/niu.csv') do |f|
    f.gets
    f.each_line do |line|
      line.chomp!
      array = line.split(',').map {|s| s.first == '"' ? s.slice!(1..-2) : s}
      array[5] = 'Male' if array[5] == 'M'
      array[5] = 'Female' if array[5] == 'F'
      p = {:first_name => array[0],
           :last_name => array[1],
           :gender => array[5],
           :staff_notes => array[44]}
      a = { :email => array[3],
            :address1 => array[2],
            :phone => array[4]}
      @person = Person.new(p)
      @current_address = CurrentAddress.new(a)
      exact = Person.find_exact(@person, @current_address)
      if exact
        # Get rid of empty values
        exact.update_attributes(p)
        @person = exact
        @person.current_address.update_attributes(a)
        @current_address = @person.current_address
      else
        @person.save
        # add address
        @person.current_address = @current_address
      end
      unless @person.user || array[3].empty?
        username_conflict = User.find_by_username(@current_address.email)
        @person.user =  User.create!(:username => array[3]) unless username_conflict
        @person.save
      end
      @ci = CampusInvolvement.find_by_campus_id_and_person_id(33940, @person.id)
      @person.campus_involvements << CampusInvolvement.new(:campus_id => 33940, :ministry_id => ministry.id, :ministry_role => 'Student', :start_date => Time.now()) unless @ci
    end
  end
end

desc "add a year, and appropriate semesters to tables"
task :add_years => :environment do
  puts "\nType a number to add that many years, and the appropriate semesters. Type '0' to cancel."
  response = STDIN.gets
  num_years_to_add = response.to_i

  Semester.create_default_semesters(num_years_to_add)
end

id
def escape_string(str)
  if str
    str.gsub(/([\0\n\r\032\'\"\\])/) do
      case $1
      when "\0" then "\\0"
      when "\n" then "\\n"
      when "\r" then "\\r"
      when "\032" then "\\Z"
      else "\\"+$1
      end
    end
  end
end

namespace :pulse do
  task :deliver_emails_working => :environment do
    Mailers::EmailMailer.send_later(:deliver_emails_working, "andrewroth@gmail.com, john.homenuke@c4c.ca")
  end
end
