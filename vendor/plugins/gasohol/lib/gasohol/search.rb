module Gasohol
  
  # The class that does the actual searching.

  class Search
    
    attr_reader :config
  
    # Default parameters that go to the GSA
    # The doc on search parameters is here: http://code.google.com/apis/searchappliance/documentation/68/xml_reference.html#request_parameters
    # nil options will not be included in query and thus will become whatever default value Google gives them (see doc)
    DEFAULT_OPTIONS = { :url => '',
                        :client => 'global',
                        :output => 'xml_no_dtd',
                        :site => 'default_collection',
                        :ud => '1',
                        :num => '10',

                        :entqr => nil,
                        :entsp => nil,
                        :oe => nil,
                        :ie => nil,
                        :start => nil,
                        :filter => nil,
                        :getfields => nil,
                        :sort => nil,
                        :requiredfields => nil,
                        :partialfields => nil }
                      
    # the parameters that google cares about and will respond to
    ALLOWED_PARAMS = DEFAULT_OPTIONS.keys
  
    def initialize(config=nil)
      # start with default values
      @config = DEFAULT_OPTIONS
      unless config.nil?
        @config.merge!(config)
      else
        raise MissingConfig, 'Missing config - you must pass some configuration options to tell gasohol how to access your GSA. See Gasohol::initialize for configuration options'
      end
    
      # make sure we have the minimum info we need to make a request
      if @config[:url].empty?
        raise MissingURL, 'Missing GSA URL - you must provide the URL to your GSA, ie: http://127.0.0.1/search'
      end
    end
  
  
    # This method does the actual searching. It accepts two parameters:
    #
    # * +query+ is the query string to google (q=)
    # * +options+ is a hash of parameters that could replace or augment DEFAULT_OPTIONS
    #
    # On most implementations that offer more than straight keyword searches you're going to want additional
    # parameters, like meta searches, to appear in the browser's URL so that the search can be uniquely identified
    # and run again. These parameters will not be formatted correctly for Google. So you'll want to extend Gasohol and
    # write your own impementation of this method that at the end will call super and pass in a final query string
    # and hash of options.
    #
    # == Example
    # You have an application that searches for pizzas. You want your URL to look something like:
    #
    #   http://pizzafinder.com/search?keyword=deep+dish&size=16&toppings=cheese
    #
    # The GSA doesn't know what to do with 'keyword,' 'size,' or 'toppings' so you need to turn those into something
    # it does understand. So you might extend this method to look like:
    #
    #   class PizzaFinder > Gasohol::Search
    #     def search(parts,options={})
    #       super("#{query} inmeta:panSize=#{parts[:size]} inmeta:toppings~#{parts[:toppings]")
    #     end
    #   end
    #
    # And then use it like so (+params+ is the default Ruby on Rails hash of URL values):
    #
    #   the_finder = PizzaFinder.new(config)
    #   pizzas = the_finder.search(params)
    #
    # That string is appeneded to the GSA url and now it knows how to search:
    #
    #   http://gsa.pizzafinder.com/search?q=deep+dish+inmeta:panSize=16+inmeta:toppings~cheese&site=etc,etc,etc
    #
    # The result that comes back is ready to be used in your app (looping through +pizzas.results+ and displaying them
    # however you like
  
    def search(query="",options={},request_string=nil)

      all_options = @config.merge(options)    # merge options that were passed directly to this method
      full_query_path = request_string.present? ? request_string : query_path(query,all_options)     # creates the full URL to the GSA
      
      begin
        agent = Mechanize.new

        Rails.logger.info "\tGSA call (#{Date.today}) #{full_query_path}"
        page = agent.get(full_query_path) # call the GSA with our search
        
        xml = Hpricot(page.body)

      rescue => e    # error with results (the GSA barfed?)
        LOGGER.error("\nERROR WITH GOOGLE SEARCH APPLIANCE RESPONSE: \n"+e.class.to_s+"\n"+e.message+"\n")
      end

      
      begin
        if all_options[:count_only] == true
          return xml.search(:m).inner_html.to_i || 0      # if all we really care about is the count of records from google, return just that number and get the heck outta here
        end
        
        rs = parse_result_set(query,full_query_path,xml,all_options[:num].to_i)      # otherwise create a real resultset
        if rs.total_results > 0             # if there was at least one result, parse the xml
          # rs.total_featured_results = xml.search(:gm).size
          rs.featured = xml.search(:gm).collect { |xml_featured| parse_featured(xml_featured) }           # get featured results (called 'sponsored links' on the results page, displayed at the top)
          rs.results = xml.search(:r).collect { |xml_result| parse_result(xml_result) }                   # get regular results
        end
      rescue => e
        LOGGER.error("\nERROR PARSING GOOGLE SEARCH APPLIANCE RESPONSE: \n"+e.class.to_s+"\n"+e.message+"\n")
      end

      return rs
    end

    # Optionally accept the entire request as a string and just trust that it's correct
    def search_request_string(request_string)
      search("",{},request_string)
    end


    private
    
    # Creates the combination of the URL, query and options into one big URI
    def query_path(query,options)
      url = options.delete(:url)  # sets url to the value of options[:url] and then removes it from the hash

      output = "#{url}#{url.include?('?') ? '&' : '?'}q=#{CGI::escape(query)}"
      
      options.each do |option|
        output += "&#{CGI::escape(option.first.to_s)}=#{CGI::escape(option.last.to_s)}" unless option.last.nil?
      end
      output
    end
    
    # Parses info for the result set (override this and use your own extended ResultSet class if you'd like)
    def parse_result_set(query,path,xml,num)
      ResultSet.new(query,path,xml,num)
    end
    
    # Parses featured results (override this and use your own extended Featured class if you'd like)
    def parse_featured(xml)
      Featured.new(xml)
    end
    
    # Parses regular results (override this and use your own extended Result class if you'd like)
    def parse_result(xml)
      Result.new(xml)
    end
  
  end
end