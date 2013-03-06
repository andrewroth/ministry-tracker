def ma?
  ENV['system'] == 'ma'
end

ENV['target'] ||= 'moose'
set :moonshine_apply, false

def stage?() %w(emu stage staging).include?(ENV['target']) end
def dev?() %w(dev moose).include?(ENV['target']) end
def prod?() ENV['target'] == 'prod' end

set :application, "ministry-tracker"
set :user, 'deploy'
set :use_sudo, false
set :host, stage? || dev? ? 'emu.powertochange.com' : 'pat.powertochange.org'
set :keep_releases, 3

set :scm, "git"
set :repository, "git://github.com/andrewroth/#{application}.git"
set :branch, if prod? then 'pulse_cdm' elsif stage? then 'c4c.staging' else 'c4c.dev' end
set :deploy_via, :checkout
path = if ma?
         'mt.ministryhacks.com'
       elsif stage?
         'emu.powertochange.com'
       elsif dev?
         'moose.powertochange.com'
       elsif prod?
         'pulse.powertochange.com'
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

before :"deploy:create_symlink", :"deploy:before_symlink"
deploy.task :before_symlink do
  # set up tmp dir
  run "mkdir -p -m 770 #{shared_path}/tmp/{cache,sessions,sockets,pids}"
  run "rm -Rf #{release_path}/tmp"
  link_shared 'tmp'

  # other shared files / folders
  link_shared 'log', :overwrite => true
  link_shared 'config/database.yml', :overwrite => true
  link_shared 'config/session.yml', :overwrite => true
  link_shared 'config/mailer.yml', :overwrite => true
  link_shared 'config/civicrm.yml', :overwrite => true
  link_shared 'config/koala.yml', :overwrite => true
  link_shared 'config/initializers/eventbright.rb', :overwrite => true

  profile_pic_prefix = if stage? then 'emu_stage' elsif dev? then 'emu_dev' elsif prod? then 'emu' end
  link_shared "public/#{profile_pic_prefix}.profile_pictures"

  #sudo "/opt/ruby/bin/god restart dj-#{if stage? then 'emu' elsif dev? then 'dev' elsif prod? then 'pulse' end}"
  run "cd #{release_path} && git checkout -b #{fetch(:branch)} origin/#{fetch(:branch)}"
  run "cd #{release_path} && git submodule init"
  run "cd #{release_path} && git submodule update"
end

after :"deploy:create_symlink", :"deploy:after_symlink"
deploy.task :after_symlink do
  run "ruby /etc/screen.d/dj_#{if dev? then 'moose' elsif stage? then 'emu' else 'pulse' end}.rb"
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
