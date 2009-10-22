$attachment_storage_mode = !Rails.env.test? && File.exists?(Rails.root.join('config','amazon_s3.yml')) ? :s3 : :file_system
