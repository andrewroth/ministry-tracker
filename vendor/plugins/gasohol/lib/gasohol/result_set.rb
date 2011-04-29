module Gasohol
  
  # ResultSet is the object that is returned when you call Gasohol::Search::search. It contains the query terms and path that you gave to
  # Gasohol::Search::search as well as info returned by the GSA's preamble. It is mostly information about how the GSA interpreted your 
  # search query and a couple other details about the client that requested the info:
  #
  #   <TM>0.190738</TM>
  #   <Q>
  #     marathon inmeta:category=activities -inmeta:channel=Shooting inmeta:latitude:32.0217..33.4689 inmeta:longitude:116.2883..118.0089 inmeta:startDate:daterange:2009-01-27..
  #   </Q>
  #   <PARAM name="entsp" value="a__active_policy" original_value="a__active_policy"/>
  #   <PARAM name="ip" value="70.167.183.79" original_value="70.167.183.79"/>
  #   <PARAM name="num" value="1" original_value="1"/>
  #   <PARAM name="q" value="marathon inmeta:category=activities -inmeta:channel=Shooting inmeta:latitude:32.0217..33.4689 inmeta:longitude:116.2883..118.0089 inmeta:startDate:daterange:2009-01-27.." original_value="marathon+inmeta%3Acategory%3Dactivities+-inmeta%3Achannel%3DShooting+inmeta%3Alatitude%3A32.0217..33.4689+inmeta%3Alongitude%3A116.2883..118.0089+inmeta%3AstartDate%3Adaterange%3A2009-01-27.."/>
  #   ... more params here ...
  #
  # All of these params are available in ResultSet::params and are accessed by their GSA name:
  #   result_set.params[:num] => 1
  #   result_set.params[:ie] => UTF-8
  #
  # Some other ones that may not be as self-evident:
  #   @google_query => the keyword query that was sent into Gasohol::Search::search
  #   @full_query_path => the complete URL to the GSA that Gasohol requests
  #   @time =>            the GSA's <TM> value
  #   @from_num =>        the starting number of the current set of results (GSA's <RES SN=""> value)
  #   @to_num =>          the ending number of the current set of results (GSA's <RES EN=""> value)
  #   @total_results =>   the total number of results that the GSA has for the given search (not the number of results in this set, but ALL results, like Google.com says 1-10 of 1,435,000 results)
  #   @featured =>        an array containing featured results (sponsored link results)
  #   @results =>         an array containing regular results
  #
  # +ResultSet+ is compatible with the <tt>will_paginate</tt> plugin http://wiki.github.com/mislav/will_paginate
  # Just give this entire result set to it and you'll get page numbers and easy navigation
  #   rs = search('pizza')
  #   will_paginate(rs)
  
  class ResultSet
                        
    attr_reader :google_query, :full_query_path, :total_results, :total_featured_results, :params, :results, :featured, :from_num, :to_num, :time, :location
    attr_reader :per_page, :total_pages, :current_page, :previous_page, :next_page   # for will_paginate
    attr_accessor :results, :featured
    
    def initialize(query,full_query_path,xml,num_per_page = 10)
      @google_query = query
      @full_query_path = full_query_path
      @time = xml.search(:tm).inner_html.to_f || 0
      @total_results = xml.search(:m) ? xml.search(:m).inner_html.to_i : 0
      if xml.at(:res)
        @from_num = xml.at(:res).attributes['sn'].to_i
        @to_num = xml.at(:res).attributes['en'].to_i
      end
      @params = {}
      xml.search(:param).each do |param|
        @params.merge!({param.attributes['name'].to_sym => param.attributes['value'].to_s})
      end
      # intialize to empty arrays, Gasohol::Search will add these
      @featured = []
      @results = []
      
      # for will_paginate
      @per_page = num_per_page
      @total_pages = (@total_results.to_f / num_per_page).ceil
      @current_page = (@from_num.to_f / num_per_page).ceil
      @previous_page = (@current_page - 1 == 0) ? nil : @current_page - 1
      @next_page = (@current_page + 1 > @total_pages) ? nil : @current_page + 1

    end
    
  end
end