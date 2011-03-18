namespace :global_dashboard do
  task :reload => :environment do
    GlobalProfile.delete_all
    GlobalProfile.import

    GlobalArea.delete_all
    GlobalCountry.delete_all
    GlobalCountry.import_stages
    GlobalCountry.import_whq
    GlobalCountry.import_demog
    GlobalCountry.import_fiscal
    GlobalCountry.import_staff_count
  end
end
