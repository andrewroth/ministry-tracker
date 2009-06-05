def clear_everything
  # get rid of the data that comes with the core MT
  Ministry.delete_all
  MinistryInvolvement.delete_all
  MinistryCampus.delete_all
end

def setup_ministries
  # set us up
  p2c = Ministry.create! :name => 'Power to Change Ministries'
  @c4c = Ministry.create! :name => 'Campus for Christ', :parent => p2c
end

def setup_roles
  # rename missionary to staff
  missionary = StaffRole.find :first, :conditions => { :name => 'Missionary' }
  if missionary
    missionary.name = "Staff"
    missionary.save!
  end
  
  # add Alumni, Staff Alumni
  alumni = @c4c.student_roles.find_or_create_by_name 'Alumni'
  alumni.save!
  staff_alumni = @c4c.staff_roles.find_or_create_by_name 'Staff Alumni'
  staff_alumni.save!
end

def setup_directory_view
  # we don't have a Website option
  column = Column.find_by_title 'Website'
  return unless column
  column.view_columns.first.delete
  column.delete
end

def setup_campuses
  # I've been unable to get the mappings.yml working properly after a migrate:reset,
  # so I'm resorting to pure sql
  ActiveRecord::Base.establish_connection "ciministry_#{Rails.env}"
  campuses = Campus.find_by_sql "select c.campus_shortDesc, c.campus_id from cim_hrdb_campus c left join cim_hrdb_province p on c.province_id = p.province_id left join cim_hrdb_country ct on ct.country_id = p.country_id where country_shortDesc = 'CAN';"
  ActiveRecord::Base.establish_connection Rails.env
  for c in campuses
    @c4c.ministry_campuses.create! :campus_id => c.campus_id
  end
end

def theyre_really_sure
  return true if @last_choice
  STDOUT.print "warning: this WILL break your MT database data.  Use it only on a fresh mt install.\nContinue? (y/n) "
  cont = STDIN.gets.chomp.downcase
  return @last_choice = (cont == 'y')
end

def switch_to_core
  if File.exists? "#{RAILS_ROOT}/config/mappings.yml"
    File.rename "#{RAILS_ROOT}/config/mappings.yml",
              "#{RAILS_ROOT}/config/mappings.yml.temp"
  end
end

def switch_to_emu
  if File.exists? "#{RAILS_ROOT}/config/mappings.yml.temp"
    File.rename "#{RAILS_ROOT}/config/mappings.yml.temp",
              "#{RAILS_ROOT}/config/mappings.yml"
  end
end

namespace :canada do
  desc "Sets up the movement tracker for the canadian ministry"
  task :setup => :environment do
    exit unless theyre_really_sure

    puts "Setting up the CMT for the Canadian schema..."
    clear_everything
    setup_ministries
    setup_directory_view
    setup_roles
    setup_campuses
    puts "Done."
  end

  desc "Resets the CMT database, then run the canada task to set it up for the cim_hrdb"
  task :reset do
    return unless theyre_really_sure
    switch_to_core
    Rake::Task["db:migrate:reset"].invoke
    switch_to_emu
    Rake::Task["canada:setup"].invoke
  end

  desc "Imports all Canadian cim_hrdb assignments to a corresponding ministry/campus involvment."
  task :import => :environment do
    total = Person.count
    ten_percent = total / 10
    i = j = 0
    for p in Person.all(:include => :assignments)
      # give some visual indication of how it's going
      i += 1; j += 1
      if j > ten_percent
        puts "#{(i.to_f / total.to_f * 100).to_i}%"
        j = 0
      end

      p.map_cim_hrdb_to_mt
    end
    puts "100%"
  end
end
