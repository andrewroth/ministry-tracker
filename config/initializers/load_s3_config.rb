if File.exist?(RAILS_ROOT + "/config/amazon_s3.yml")
  raw_config = File.read(RAILS_ROOT + "/config/amazon_s3.yml")
  S3_CONFIG = YAML.load(raw_config)[RAILS_ENV].symbolize_keys
else
  S3_CONFIG = {}
end