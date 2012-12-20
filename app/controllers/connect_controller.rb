require 'uri'

class ConnectController < ApplicationController

  def import_contacts_log
    @yml_config_path = CiviCRM::YML_CONFIG_PATH
    config = HashWithIndifferentAccess.new(YAML.load_file(Rails.root.join(@yml_config_path))[(ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development')])

    @num_lines = params[:n].try(:to_i) || 10000

    @log_path = config[:log_path] || 'log/civicrm_api.log'
    @log_path = 'log/civicrm_api.log' unless File.exists?(@log_path)

    if File.exists?(@log_path)
      tail_output = `tail -n #{@num_lines} #{@log_path}`
      @unfiltered_log_lines = tail_output.split("\n[").collect { |o| "#{o[0] == '[' ? '' : '['}#{o}" }
      @include_log_tag = '[IMPORT CONTACTS]'
      @log_lines = @unfiltered_log_lines.select { |line| line.include?(@include_log_tag) }
    end

    # We just use this to try to check if the import task is in the crontab
    @crontab_cmd = "flock -n tmp/connect.lock rake connect:import_contacts"
    crontab_list_output = `crontab -l`
    # detect a line that includes the cmd and doesn't start with a #
    @cronjob_installed = crontab_list_output && crontab_list_output.split("\n").detect { |line| line.include?(@crontab_cmd) && line !~ /\A\s*#.*\z/ }.present? ? true : false
  end

end