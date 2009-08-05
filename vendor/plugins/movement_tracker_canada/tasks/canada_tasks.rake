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
  desc "Imports all Canadian cim_hrdb assignments to a corresponding ministry/campus involvment."
  task :import => :environment do
    total = Person.count
    ten_percent = total / 10
    i = j = 0
    for p in Person.all(:include => { :assignments => :assignmentstatus })
      throw p.inspect if p.person_id == 1
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

  desc "Moves the mappings.yml file to a temporary file, so that the core db is hit"
  task :core do
    switch_to_core
  end

  # since there's a :core task, let's have an emu one as well
  desc "Puts the mappings.yml file back in place, so that the intranet db is hit again"
  task :emu do
    switch_to_emu
  end
end 


namespace :db do
 task :load_config => [ "canada:core" ] do   
   switch_to_emu
 end
end
