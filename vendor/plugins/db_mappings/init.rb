require 'db_mappings'

config.after_initialize do
  # Load any custom model files
  @@map_hash ||= ''
  if @@map_hash && @@map_hash['lib_path']
    for file in Dir.glob("#{File.join(@@map_hash['lib_path'])}/**")
      # require the app/model/name.rb manually, apparently required to mix in
      app_models_file = File.join(RAILS_ROOT, 'app','models', File.basename(file))
      require app_models_file if File.exist? app_models_file
      # require the new lib_path one
      require file
    end
  end
end
