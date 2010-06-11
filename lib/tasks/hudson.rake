class CustomLogger < Logger
  def format_message(severity, timestamp, progname, msg)
    "#{msg}\n"
  end
end

task :hudson => [ "test:mh_common:lock" ] do
  begin
    ENV['AGGREGATE'] = "coverage/aggregate.data"
    Rake::Task["db:test:prepare:all"].execute
    Rake::Task["test:coverage"].execute
  rescue
    $logger.info "In rescue block"
    raise
  ensure
    Rake::Task["test:mh_common:lock:release"].execute
  end
end
