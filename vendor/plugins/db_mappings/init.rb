require 'db_mappings'
require 'require_model'

config.after_initialize do
  # Load any custom model files after the original ones, so that the original app 
  # can be extended without modifying the original app/models (instead,
  # require the base app/models files in the lib_path model files)
  @@map_hash ||= ''
  if @@map_hash && @@map_hash['lib_path']
    # move lib_path folder last
    ActiveSupport::Dependencies.load_paths.delete @@map_hash['lib_path']
    ActiveSupport::Dependencies.load_paths.unshift @@map_hash['lib_path']
  end
end
