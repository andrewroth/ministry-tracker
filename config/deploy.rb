# deploy.rb -- set application to one of the apps listed in moonshine_manifest.yml
set :application, 'pulse'
set :default_stage, "dev"
require 'capistrano/ext/multistage'
