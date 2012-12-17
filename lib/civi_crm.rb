require 'net/http'

module CiviCRM
  YML_CONFIG_PATH = 'config/civicrm.yml'

  class API
    attr_accessor :max_row_count, :log_tags

    def initialize(options = {})
      begin
        @rails_env = Rails.respond_to?(:env) ? Rails.env : (ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development')

        # get config for current rails env
        yml_config_path = options[:yml_config_path] || YML_CONFIG_PATH
        @config = HashWithIndifferentAccess.new(YAML.load_file(Rails.root.join(yml_config_path))[@rails_env])

        # setup logger
        @log_tags = options[:log_tags] || @config[:log_tags] || []
        @log_path = options[:log_path] || @config[:log_path] || 'log/civicrm_api.log'
        @logger = Logger.new(@log_path, 'monthly')
        @logger.level = @rails_env == 'development' ? Logger::DEBUG : Logger::INFO

        log :debug, "Initializing new #{self.class} with #{yml_config_path} in #{@rails_env} environment."

        raise "No config supplied, the config file should be #{yml_config_path}" unless @config.present?

        # make sure we have the required config values
        [:rest_api_url, :api_key, :key].each do |required_val|
          raise "'#{required_val}' required config value not supplied, the config file is #{yml_config_path}" unless @config[required_val].present?
        end

        @max_row_count = options[:max_row_count] || @config[:max_row_count] || 1000

      rescue => e
        log :error, e
      end
    end


    def log(severity, message, exception = nil)
      if message.is_a?(Exception)
        exception = message
        message = "Exception"
      end

      message = "#{message}: #{exception.class}: #{exception.message}" if exception.present?

      severity = :info unless [:error, :warn, :info, :debug].include?(severity.to_sym)

      tags = [Time.now]
      tags += @log_tags || []
      tags << severity.to_s.upcase unless severity == :info
      tags = tags.collect { |t| "[#{t}]" }.join(' ')

      message = "#{tags} #{message}"

      puts message
      @logger.send(severity, message)
    end


    [:get, :create, :delete, :update].each do |action|
      define_method(action) do |*args|
        entity, options = *args
        options ||= {}

        params = options[:with]
        includes = options[:include]
        hashed_by = options[:hashed_by]

        parsed_json = parsed_json_response(params.merge({ :entity => entity, :action => action, :json => 1 }))

        begin
          entities = hashed_by.present? ? HashWithIndifferentAccess.new : []

          parsed_json['values'].each_pair do |id, attributes|
            attributes.merge!(get_entity_includes(id, includes)) if includes.present?
            entity_instance = Entity.new(entity, attributes.merge!({ :id => id }))

            if hashed_by.present?
              entities[entity_instance.attribute(hashed_by)] = entity_instance
            else
              entities << entity_instance
            end
          end

          raise "We don't have the same count of entities that CiviCRM returned" if entities.size != parsed_json['count']
        rescue => e
          log :error, e
          return nil
        end

        entities
      end
    end


    private

    def get_entity_includes(entity_id, includes)
      return nil unless includes.present?

      begin
        entity_includes = {}

        if includes.is_a?(Array)
          includesHashed = HashWithIndifferentAccess.new
          includes.each { |i| includesHashed[i.to_sym] = {} }
          includes = includesHashed
        end

        includes.each_pair do |entity, options|
          params = options[:with] || {}
          foreign_key = options[:foreign_key].try(:to_sym) || :entity_id
          hashed_by = options[:hashed_by]

          params.merge!({ :entity => entity, :action => :get, foreign_key => entity_id })

          parsed_json = parsed_json_response(params)

          entity_key = entity.to_s.pluralize.underscore.to_sym
          entity_array = entity_includes[entity_key] = hashed_by.present? ? HashWithIndifferentAccess.new : []

          parsed_json['values'].each_pair do |id, attributes|
            entity_instance = Entity.new(entity, attributes.merge({ :id => id }))

            if hashed_by.present?
              entity_array[entity_instance.attribute(hashed_by)] = entity_instance
            else
              entity_array << entity_instance
            end
          end
        end
      rescue => e
        log :error, e
        return nil
      end

      entity_includes
    end

    def parsed_json_response(params)
      begin
        response = call(params.merge!({ :json => 1 }))

        parsed_json = JSON::Parser.new(response.body).parse

        raise "CiviCRM returned an error: #{parsed_json['error_message']}" unless parsed_json['is_error'] == 0
        log :warn, "CiviCRM returned the maximum number of results (configured to #{@max_row_count})!" if @max_row_count == parsed_json['count']
      rescue => e
        log :error, e
        return nil
      end

      parsed_json
    end

    def call(params = {})
      params = params.merge({
        :key => @config[:key],
        :api_key => @config[:api_key],
        :rowCount => params[:rowCount] || params[:row_count] || @max_row_count,
        :json => params[:json] || 1,
        :debug => params[:debug] || @rails_env == 'development' ? 1 : 0
      })
      params.delete(:row_count)

      begin
        uri = URI.parse("#{@config[:rest_api_url]}?#{params.to_query}")
      rescue => e
        log :error, 'Failed to parse URI', e
        return nil
      end

      begin
        [:entity, :action, :api_key, :key].each { |required_param| raise "'#{required_param}' required parameter not supplied for call to CiviCRM" unless params[required_param].present? }

        if [:create, :delete, :update].include?(params[:action].to_sym)
          log :debug, "POST #{uri}"
          http = Net::HTTP.new(uri.host, uri.port)
          request = Net::HTTP::Post.new(uri.request_uri)
          request.set_form_data(params)
          response = http.request(request)
        else
          log :debug, "GET #{uri}"
          response = Net::HTTP.get_response(uri)
        end

        raise "Unsuccessful HTTP request: #{response}" unless response.is_a? Net::HTTPOK
      rescue => e
        log :error, e
        return nil
      end

      response
    end
  end


  class Entity
    attr_reader :attributes

    def initialize(entity_type, attributes, includes = nil)
      @entity_type = entity_type

      if attributes.is_a?(String)
        @attributes = HashWithIndifferentAccess.new({ :value => attributes })

        self.class.send(:define_method, :value) { @attributes[attribute] }
      else
        @attributes = HashWithIndifferentAccess.new(attributes)

        @attributes.each_pair do |attribute, attribute_value|
          self.class.send(:define_method, attribute) { @attributes[attribute] }
        end
      end

      get_includes(includes) if includes
    end

    def attribute(name)
      @attributes[name]
    end
    alias_method :attr, :attribute
  end
end