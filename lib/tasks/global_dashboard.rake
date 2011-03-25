namespace :gd do
  task :reset => :environment do
    puts "Resetting global profile data..."
    GlobalCountry.reset_data
  end
end
