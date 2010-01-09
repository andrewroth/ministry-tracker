def ma?
  ENV['system'] == 'ma'
end

def dev?() %w(emu dev).include?(ENV['target']) end
def stage?() %w(stage moose).include?(ENV['target']) end
def prod?() ENV['target'] == 'prod' end

set :application, "ministry-tracker"
set :user, 'deploy'
set :use_sudo, false
set :host, ma? ? "ministryapp.com" : "pat.powertochange.org"
set :keep_releases, 3

set :scm, "git"
set :repository, "git://github.com/twinge/#{application}.git"
set :branch, if ma? then 'dev' elsif stage? then 'moose' else 'emu' end
set :deploy_via, :remote_cache
path = if ma?
         'mt.ministryhacks.com'
       elsif dev?
         'emu.campusforchrist.org'
       elsif stage?
         'moose.campusforchrist.org'
       elsif prod?
         'pulse.campusforchrist.org'
       end
set :deploy_to, "/var/www/#{path}"
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
  link_shared 'config/database.emu.yml', :overwrite => true
  profile_pic_prefix = if stage? then 'emu_stage' elsif dev? then 'emu_dev' elsif prod? then 'emu' end
  link_shared "public/#{profile_pic_prefix}.profile_pictures"

  sudo "/opt/ruby/bin/god restart dj-moose"
end

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is not applicable to Passenger"
    task t, :roles => :app do ; end
  end

  desc "runs db:rebuild remotely (resets and reseeds)"
  task :rebuild do
    puts "this will DESTROY the remote database, are you sure?"
    return unless gets.chomp == 'y'
    rake = fetch(:rake, "rake")
    rails_env = fetch(:rails_env, "production")

    run "cd #{current_path}; #{rake} RAILS_ENV=#{rails_env} db:rebuild"
  end

  desc "runs db:seed remotely"
  task :seed do
    rake = fetch(:rake, "rake")
    rails_env = fetch(:rails_env, "production")

    run "cd #{current_path}; #{rake} RAILS_ENV=#{rails_env} db:seed"
  end

  namespace :views do
    desc "runs cmt:views:rebuild remotely"
    task :rebuild do
      rake = fetch(:rake, "rake")
      rails_env = fetch(:rails_env, "production")

      run "cd #{current_path}; #{rake} RAILS_ENV=#{rails_env} cmt:views:rebuild"
    end
  end
end
