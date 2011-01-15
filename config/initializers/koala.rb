# config/initializers/koala.rb
# Monkey-patch in Facebook config so Koala knows to
# automatically use Facebook settings from here if none are given

module Facebook
  CONFIG = YAML.load_file(Rails.root.join("config/koala.yml"))[Common::STAGE]
  APP_ID = CONFIG['app_id']
  SECRET = CONFIG['secret_key']
  CANVAS_URL = CONFIG['canvas_url']
  FANPAGE_URL = "http://www.facebook.com/campusforchrist"
  SIGNUP_PERMS = "email, user_mobile_phone, user_address"
end

Koala::Facebook::OAuth.class_eval do
  def initialize_with_default_settings(*args)
    case args.size
      when 0, 1
        raise "application id and/or secret are not specified in the config" unless Facebook::APP_ID && Facebook::SECRET
        initialize_without_default_settings(Facebook::APP_ID.to_s, Facebook::SECRET.to_s, args.first)
      when 2, 3
        initialize_without_default_settings(*args)
    end
  end

  alias_method_chain :initialize, :default_settings
end
