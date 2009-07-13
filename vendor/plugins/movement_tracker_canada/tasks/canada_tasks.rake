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



task :switch_to_core do
 switch_to_core
end

namespace :db do
 task :migrate => [:switch_to_core] do   
   switch_to_emu
 end


#namespace :migrate do
# task :reset => [:switch_to_core] do   
#   switch_to_emu
# end 
#end

 
end

#def theyre_really_sure
#  return true if @last_choice
#  STDOUT.print "warning: this MAY break your MT database data.  Recommended usage only on fresh install, but it *should* work on an existing emu install.\nContinue? (y/n) "
#  cont = STDIN.gets.chomp.downcase
#  return @last_choice = (cont == 'y')
#end


#Seed setup
#namespace :emu do
#  task :reset do
#    return unless theyre_really_sure
#    Rake::Task["db:reset"].invoke
#    Rake::Task["db:seed"].invoke
#    #Rake::Task["canada:import"].invoke
#    puts "Database recreated, fixtures made, and HRDB data imported"
#  end
#end
    

