module Gasohol
  
  # Parses standard results
  
  class Result
  
    attr_reader :result,:num,:mime,:level,:url,:url_encoded,:host,:path,:file,:title,:language,:abstract,:crawl_date,:has,:meta,:featured
  
    def initialize(xml)
      @num = xml.attributes['n'].to_i
      @mime = xml.attributes['mime'] || 'text/html'
      @level = xml.attributes['l'].to_i > 0 ? xml.attributes['l'].to_i : 1
      @url = xml.at(:u) ? xml.at(:u).inner_html : ''
      @url_encoded = xml.at(:ue) ? xml.at(:ue).inner_html : ''
      uri = URI.parse(@url)
      @host = uri.host
      @path = File.dirname(CGI::unescape(uri.path))
      @file = File.basename(CGI::unescape(uri.path))
      @title = xml.at(:t) ? xml.at(:t).inner_html : ''
      @language = xml.at(:lang) ? xml.at(:lang).inner_html : ''
      @abstract = xml.at(:s) ? xml.at(:s).inner_html.gsub(/&lt;br&gt;/i,'').gsub(/\.\.\./,'') : ''
      # result[:date] = xml.at(:fs) ? Chronic.parse(xml.at(:fs)[:value]) : ''
      @crawl_date = xml.at(:crawldate) ? Chronic.parse(xml.at(:crawldate).inner_html) : ''
      if xml.at(:has)
        @has = {}
        if xml.at(:has).at(:c)
          @has[:cache] = {}
          @has[:cache][:size] = xml.at(:has).at(:c).attributes['sz']
          @has[:cache][:cid] =xml.at(:has).at(:c).attributes['cid']
          @has[:cache][:encoding] = xml.at(:has).at(:c).attributes['enc']
        end
      end
      @meta = {}
      xml.search(:mt).each do |meta|
        key = meta.attributes['n'].gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').gsub(/([a-z\d])([A-Z])/,'\1_\2').tr("-", "_").downcase.to_sym   # change meta value into underscores instead of camelcase
        value = key.to_s.match(/date/i) ? Time.parse(meta.attributes['v'].to_s) : meta.attributes['v'].to_s.gsub(/\\/,'/')    # if the name contains 'date' assume it's a valid date object and convert, otherwise just use the string but convert backslashes to forward ones
        if @meta[key]
          if @meta[key].is_a? String
            save_me = @meta[key]
            @meta[key] = [save_me]
          end
          @meta[key] << value     # key already exists, append to array
        else
          @meta.merge!({ key => value })               # key doesn't exist, merge hash
        end
      end
      @featured = false
    end
  
  end
end