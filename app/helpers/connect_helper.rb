module ConnectHelper
  def preprocess_log_line(line)
    processed_line = line

    URI.extract(processed_line).each do |url|
      next unless url.include?('http')
      processed_line.gsub! url, link_to(url, url, { :target => '_blank' })
    end

    processed_line.scan(/(Pulse survey contact (\d+))/).each do |match|
      processed_line.gsub! match.first, link_to(match.first, survey_contact_path(match.second), :target => '_blank')
    end

    processed_line.scan(/(Connect contact (\d+))/).each do |match|
      processed_line.gsub! match.first, link_to(match.first, "http://#{ENV['RAILS_ENV'] == 'production' ? '' : 'staging'}connect.powertochange.org/civicrm/contact/view?reset=1&cid=#{match.second}", :target => '_blank')
    end

    processed_line.gsub! "\n", '<br>&nbsp;'

    processed_line
  end
end