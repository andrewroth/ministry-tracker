class ConnectController < ApplicationController

  def import_contacts_log
    @yml_config_path = CiviCRM::YML_CONFIG_PATH
    config = HashWithIndifferentAccess.new(YAML.load_file(Rails.root.join(@yml_config_path))[(ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development')])

    @num_lines = params[:n].try(:to_i) || 1000

    @log_path = config[:log_path] || 'log/civicrm_api.log'
    @log_path = 'log/civicrm_api.log' unless File.exists?(@log_path)

    if File.exists?(@log_path)
      tail_output = `tail -n #{@num_lines} #{@log_path}`
      @unfiltered_log_lines = tail_output.split("\n")

      @include_log_tag = '[IMPORT CONTACTS]'
      @exclude_log_tag = '[DEBUG]'

      @log_lines = @unfiltered_log_lines.select { |line| line.include?(@include_log_tag) && !line.include?(@exclude_log_tag) }
    end

    @crontab_list_output = `crontab -l`
    @crontab_cmd = "flock -n tmp/connect_import_contacts_task.lock rake connect:import_contacts"
  end
end