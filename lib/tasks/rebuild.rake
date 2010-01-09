namespace :db do
  desc "does db:reset then db:seed"
  task :rebuild => [ 'db:reset', 'db:seed', 'canada:import' ] do
  end
end
