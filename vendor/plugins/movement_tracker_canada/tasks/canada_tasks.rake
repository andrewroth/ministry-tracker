def clear_everything
  # get rid of the data that comes with the core MT
  Ministry.delete_all
  MinistryInvolvement.delete_all
end

def setup_ministries
  # set us up
  p2c = Ministry.create! :name => 'Power to Change Ministries'
  @c4c = Ministry.create! :name => 'Campus for Christ', :parent => p2c
end

def setup_roles
  # rename missionary to staff
  missionary = StaffRole.find_by_name 'Missionary'
  missionary.name = "Staff"
  missionary.save!
  
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
    puts "Done."
  end

  task :reset do
    return unless theyre_really_sure
    switch_to_core
    Rake::Task["db:migrate:reset"].invoke
    switch_to_emu
    Rake::Task["canada:setup"].invoke
  end
end
