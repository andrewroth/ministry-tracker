require 'ruby-debug'

def clear_everything
  puts "Clearing existing data..."
  # get rid of the data that comes with the core MT
  Ministry.delete_all
  MinistryInvolvement.delete_all
  MinistryCampus.delete_all
end

P2C_NAME = 'Power to Change Ministries'

def setup_ministries
  puts "Setting up ministries..."
  # set us up
  p2c = Ministry.find_or_create_by_name P2C_NAME
  p2c.save
  @c4c = Ministry.find_or_create_by_name_and_parent_id 'Campus for Christ', p2c.id
  @c4c.save
end

def setup_roles
  puts "Setting up roles..."
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
  puts "Setting up directory views..."

  # we don't have a Website option
  ws = Column.find_by_title 'Website'
  if ws
    ws.view_columns.each { |vc| vc.destroy }
    ws.destroy
  end

  # clear out old views
  view_ids = View.all.collect &:id
  used_views_ids = Ministry.all.collect{ |m| m.views.collect &:id }.flatten
  View.find(view_ids - used_views_ids).each { |v| v.destroy }

  # add campus column and school year columns
  c = Column.find_by_title 'Campus'
  sy = Column.find_by_title 'School Year'
  View.all.each do |v|
    vc = v.view_columns.find_or_create_by_column_id c.id
    vc.save
    vc = v.view_columns.find_or_create_by_column_id sy.id
    vc.save

    v.build_query_parts!
  end

  # make address columns hit Person directly as our schema is lke that
  for t in %w(Street City Zip Email)
    c = Column.find_by_title t
    c.from_clause = 'Person'
    c.save!
  end

  # state is a special case
  c = Column.find_by_title 'State'
  c.source_column = 'person_local_province_id'
  c.save!

  # rebuild since changing views
  View.all.each { |v| v.build_query_parts! }
end

def setup_campuses
  # I've been unable to get the mappings.yml working properly after a migrate:reset,
  # so I'm resorting to pure sql
  ActiveRecord::Base.establish_connection "ciministry_#{Rails.env}"
  campuses = Campus.find_by_sql "select c.campus_shortDesc, c.campus_id from cim_hrdb_campus c left join cim_hrdb_province p on c.province_id = p.province_id left join cim_hrdb_country ct on ct.country_id = p.country_id where country_shortDesc = 'CAN';"
  ActiveRecord::Base.establish_connection Rails.env
  for c in campuses
    mc = @c4c.ministry_campuses.find_or_create_by_campus_id c.campus_id
    mc.save!
  end
end

def theyre_really_sure
  return true if @last_choice
  STDOUT.print "warning: this MAY break your MT database data.  Recommended usage only on fresh install, but it *should* work on an existing emu install.\nContinue? (y/n) "
  cont = STDIN.gets.chomp.downcase
  return @last_choice = (cont == 'y')
end

def switch_to_core
  move_config 'mappings.yml', 'mappings.yml.orig'
  move_config 'database.yml', 'database.yml.orig'
  copy_config 'database.emu.yml', 'database.yml'
end

def switch_to_emu
  move_config 'mappings.yml.orig', 'mappings.yml'
  move_config 'database.yml.orig', 'database.yml'
end

def move_config(a, b)
  move_file Rails.root.join('config', a), Rails.root.join('config', b)
end

def copy_config(a, b)
  copy_file Rails.root.join('config', a), Rails.root.join('config', b)
end

def move_file(a, b)
  if File.exists? a
    File.rename a, b
  end
end

require 'fileutils'

def copy_file(a, b)
  if File.exists? a
    FileUtils.cp a, b
  end
end

namespace :canada do
  desc "Sets up the movement tracker for the canadian ministry"
  task :setup => :environment do
    exit unless theyre_really_sure

    puts "Setting up the CMT for the Canadian schema..."
    clear_everything unless Ministry.find_by_name P2C_NAME
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