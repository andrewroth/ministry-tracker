def clear_everything
  # get rid of the data that comes with the core MT
  Ministry.delete_all
  MinistryInvolvement.delete_all
end

def setup_ministries
  # set us up
  p2c = Ministry.create! :name => 'Power to Change Ministries'
  c4c = Ministry.create! :name => 'Campus for Christ', :parent => p2c
end

def setup_directory_view
  # we don't have a Website option
  column = Column.find_by_title 'Website'
  column.view_columns.first.delete
  column.delete
end

namespace :canada do
  desc "Sets up the movement tracker for the canadian ministry"
  task :setup => :environment do
    STDOUT.print "warning: this WILL break your MT database data.  Use it only on a fresh mt install.\nContinue? (y/n) "
    cont = STDIN.gets.chomp.downcase

    clear_everything

    if cont == 'y'
      setup_ministries
      setup_directory_view
    end
  end
end
