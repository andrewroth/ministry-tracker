# This file is copied from vendor/plugins/movement_tracker_canada/deploy.rb
#
# Make sure to edit that file, not the one in RAILS_ROOT/config/deploy.rb
#

def ma?
  ENV['system'] == 'ma'
end

# This file 
set :application, "ministry-tracker"
set :user, 'deploy'
set :use_sudo, false
set :host, ma? ? "ministryapp.com" : "pat.powertochange.org"

set :scm, "git"
set :repository, "git://github.com/twinge/#{application}.git"
set :branch, 'dev_openlogin'
set :deploy_via, :remote_cache
set :deploy_to, "/var/www/#{ma? ? "mt.ministryhacks.com" : "emu.campusforchrist.org"}"
set :git_enable_submodules, false
set :git_shallow_clone, true

set :port, 40022 if ma?

server host, :app, :web, :db, :primary => true
after "deploy", "deploy:cleanup"

def link_shared(p, o = {})
  if o[:overwrite]
    run "rm -Rf #{release_path}/#{p}"
  end

  run "ln -s #{shared_path}/#{p} #{release_path}/#{p}"
end

deploy.task :after_symlink do
  # set up tmp dir
  run "mkdir -p -m 770 #{shared_path}/tmp/{cache,sessions,sockets,pids}"
  run "rm -Rf #{release_path}/tmp"
  link_shared 'tmp'

  # other shared files / folders
  link_shared 'log', :overwrite => true
  link_shared 'config/database.yml'
  link_shared 'vendor/plugins/movement_tracker_canada' unless ma?

  # update our plugin
  run "cd #{shared_path}/vendor/plugins/movement_tracker_canada && svn up" unless ma?
end

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is not applicable to Passenger"
    task t, :roles => :app do ; end
  end
end
