desc 'Displays a list of all locales installed in config/locales'
task :locales do
  locales_dir = File.join(RAILS_ROOT, 'config', 'locales')
  Dir["#{locales_dir}/*.rb", "#{locales_dir}/*.yml"].collect {|l| File.basename(l, '.rb')}.collect {|l| File.basename(l, '.yml')}.uniq.sort.each do |locale|
    puts locale
  end
end