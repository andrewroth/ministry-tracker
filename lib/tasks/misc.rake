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