module Gasohol
  
  # Parses the 'sponsored links' results
  class Featured
    
    attr_reader :url, :title
    
    def initialize(xml)
      @url = xml.at(:gl) ? xml.at(:gl).inner_html : ''
      @title = xml.at(:gd) ? xml.at(:gd).inner_html : ''
    end
    
  end
end